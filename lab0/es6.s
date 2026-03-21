.data
msg_in: .string "\nInserire numeri:\n"
msgout: .string "\nNumeri inseriti: "
space:  .string " ; "

.bss
buf:    .zero   255
wRes:   .zero   5                       # vettore di caratteri

.text
main:
        la      a0, msg_in              # print start message
        addi    a7, x0, 4
        ecall
        
        la      t0, wRes
        add     t1, x0, x0              # reset counter
        addi    s0, x0, 5               # upper limit
        

get_char:
        add     a0, x0, x0
        la      a1, buf
        addi    a2, x0, 255
        addi    a7, x0, 63
        ecall
        
        lb      t2, 0(a1)
        sb      t2, 0(t0)
        addi    t1, t1, 1
        addi    t0, t0, 1
        
        beq     t1, s0, print_res
        j       get_char
     
print_res:
        la      a0, msgout
        addi    a7, x0, 4
        ecall
        
        add     t1, x0, x0              # reset counter
        sub     t0, t0, s0              # reset address of starting memory
        
print_char:
        lb      t2, 0(t0)
        addi    t0, t0, 1
        addi    t1, t1, 1
        
        add     a0, x0, t2
        addi    a7, x0, 11
        ecall
        
        beq     t1, s0, exit
        
        la      a0, space
        addi    a7, x0, 4
        ecall

        j       print_char

exit:
        addi    a7, x0, 10
        ecall