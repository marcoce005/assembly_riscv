.data
vet:    .word   2, 8, 2, 7, 9, 2, 12, 7, 3, 34, 3, 1
n:      .word   12
output: .string "Max value: "

.text
main:
        la      a0, vet
        la      t0, n
        lw      a1, 0(t0)

        jal     max
        mv      s0, a0

        la      a0, output
        addi    a7, x0, 4
        ecall

        mv      a0, s0
        addi    a7, x0, 1
        ecall

        j       exit

max:                                    # a0 <--- vet address, a1 <--- number of elements
        lw      t0, 0(a0)               # t0 <--- max value
        addi    a1, a1, -1
        addi    a0, a0, 4
loop:
        lw      t1, 0(a0)
        bge     t0, t1, no_swap

        xor     t0, t0, t1              # swap t0 with t1
        xor     t1, t0, t1
        xor     t0, t0, t1
no_swap:
        addi    a1, a1, -1
        addi    a0, a0, 4
        bne     a1, x0, loop

        mv      a0, t0
        jr      ra

exit:
        addi    a7, x0, 10
        ecall