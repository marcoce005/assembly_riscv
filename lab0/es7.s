.data
msg_in: .string "\nInsert numbers: "
msg_out: .string "\nMinimum: "
DIM:    .byte   5

.bss
buf:    .zero   255
vet:    .zero   5
min:    .zero   4

.text
main:
        la      t0, DIM
        lb      s0, 0(t0)               # store DIM in s0
        la      t0, vet                 # address vet --> t0
        xor     t1, t1, t1              # reset counter
        addi    s1, x0, 0x30            # '0' ascii code
        
        la      a0, msg_in              # print init message
        addi    a7, x0, 4
        ecall
        
        la      a1, buf                 # setup to get information from stdin
        addi    a2, x0, 0xff
        addi    a7, x0, 63

get_numbers:
        xor     a0, a0, a0
        ecall
        
        lb      t3, 0(a1)
        sub     t3, t3, s1              # covert ASCII to integer
        sb      t3, 0(t0)
        addi    t0, t0, 1               # increment addres of a byte
        addi    t1, t1, 1               # increment counter
        
        beq     t1, s0, find_min
        j       get_numbers
    
find_min:
        add     t2, x0, t3              # set t2 [min value] with the last number inserted

loop:
        addi    t0, t0, -1              # set address to the last number insert
        addi    t1, t1, -1
        lb      t3, 0(t0)
        
        bge     t3, t2, no_change_min
        add     t2, x0, t3

no_change_min:
        beq     t1, x0, print_min
        j       loop
                
        
print_min:
        la      t0, min                 # store minimum in min
        sb      t2, 0(t0)
        
        la      a0, msg_out             # print out message
        addi    a7, x0, 4
        ecall
        
        add     a0, x0, t2              # print minimum number
        addi    a7, x0, 1
        ecall
    
exit:
        addi    a7, x0, 10
        ecall