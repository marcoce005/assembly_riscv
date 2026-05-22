.globl leap_year

leap_year:
        addi    sp, sp, -32
        sw      t0, 28(sp)
        sw      t1, 24(sp)
        sw      s0, 20(sp)
        sw      s1, 16(sp)
        sw      s2, 12(sp)
        sw      s3, 8(sp)
        sw      s4, 4(sp)
        sw      s5, 0(sp)

        addi    s0, x0, 100
        addi    s1, x0, 400
        addi    s2, x0, 4
        addi    s3, x0, 1
        mv      s4, a0                  # copy of arrays
        mv      s5, a1

loop:
        lw      t0, 0(a0)

        rem     t1, t0, s0
        bne     t1, x0, not_100         # t1 % 100

        rem     t1, t0, s1
        bne     t1, x0, not_400         # t1 % 400
        sw      s3, 0(a1)
        j       next

not_400:
        sw      x0, 0(a1)
        j       next

not_100:
        rem     t1, t0, s2
        bne     t1, x0, not_4
        sw      s3, 0(a1)
        j       next

not_4:
        sw      x0, 0(a1)
        j       next


next:
        addi    a2, a2, -1
        addi    a0, a0, 4
        addi    a1, a1, 1
        bnez    a2, loop

        mv      a0, s4
        mv      a1, s5

        lw      t0, 28(sp)
        lw      t1, 24(sp)
        lw      s0, 20(sp)
        lw      s1, 16(sp)
        lw      s2, 12(sp)
        lw      s3, 8(sp)
        lw      s4, 4(sp)
        lw      s5, 0(sp)
        addi    sp, sp, 32
        jr      ra