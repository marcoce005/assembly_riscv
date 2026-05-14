.data
n:      .word   19
arrow:  .string " --> "

.text
main:
        la      t0, n
        lw      s0, 0(t0)               # a0 <--- n

        mv      a0, s0
        addi    a7, x0, 1
        ecall

        jal     cal_next
        mv      s1, a0                  # s1 <--- return of cal_next

        la      a0, arrow
        addi    a7, x0, 4
        ecall
        mv      a0, s1
        addi    a7, x0, 1
        ecall

        j       exit


cal_next:
        addi    sp, sp, -4
        sw      t0, 0(sp)

        andi    t0, a0, 1
        beqz    t0, is_even

        addi    t0, x0, 3
        mul     a0, a0, t0              # a0 % 2 != 0 ---> a0 = 3 * a0 + 1
        addi    a0, a0, 1
        j       return

is_even:
        addi    t0, x0, 2
        div     a0, a0, t0              # a0 % 2 == 0 ---> a0 = a0 / 2

return:
        lw      t0, 0(sp)
        addi    sp, sp, 4
        jr      ra


exit:
        addi    a7, x0, 10
        ecall