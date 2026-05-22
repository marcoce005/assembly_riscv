.globl n_solutions

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