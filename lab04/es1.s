.data
fib_num: .byte  20
newline: .string "\n"

.bss
vet:    .zero   80

.text
main:
        la      t0, vet                 # vet address in t0
        sw      x0, 0(t0)               # set vet[0] = 0

        jal     print_val

        addi    t0, t0, 4
        addi    t1, x0, 1
        sw      t1, 0(t0)               # set vet[1] = 1

        jal     print_val

        addi    t0, t0, 4               # move vet address to the next free cell

        la      t1, fib_num
        lb      t6, 0(t1)               # upper limits in t6
        addi    t6, t6, -2              # remove the number already insertt [0, 1]
        
loop:
        beqz    t6, exit

        lw      t1, -4(t0)              # t1 <-- vet[i - 1]
        lw      t2,-8(t0)               # t2 <-- vet[i - 2]
        add     t3, t1, t2
        sw      t3, 0(t0)

        jal     print_val

        addi    t0, t0, 4
        addi    t6, t6, -1

        j       loop

print_val:
        lw      a0, 0(t0)
        addi    a7, x0, 1
        ecall
        la      a0, newline
        addi    a7, x0, 4
        ecall
        jr      ra

exit:
        addi    a7, x0, 10
        ecall