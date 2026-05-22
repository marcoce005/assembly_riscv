.data
params: .word   1, -4, 4
output: .string "Number of real solutions: "

.text
main:
        la      t0, params
        lw      a0, 0(t0)
        lw      a1, 4(t0)
        lw      a2, 8(t0)

        jal     n_solutions
        mv      s0, a0

        la      a0, output
        addi    a7, x0, 4
        ecall

        mv      a0, s0
        addi    a7, x0, 1
        ecall

        j       exit


n_solutions:
        addi    sp, sp, -4
        sw      t0, 0(sp)

        mul     a1, a1, a1              # b^2
        mul     a0, a0, a2              # a * c
        addi    t0, x0, 4
        mul     a0, a0, t0              # 4 * a * c
        sub     a1, a1, a0              # b^2 - 4 * a * c [a1 <--- Delta]

        addi    a0, x0, 2

        slt     t0, x0, a1
        bne     t0, x0, return
        
        addi    a0, a0, -1
        beq     a1, x0, return

        addi    a0, a0, -1

return:
        lw      t0, 0(sp)
        addi    sp, sp, 4
        jr      ra


exit:
        addi    a7, x0, 10
        ecall