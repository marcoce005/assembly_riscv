.data
mat:    .word   1, 3, 9, 2, 5, 7, 1, 2, 3
output: .string "det(...) = "
.text
main:
        la      t0, mat
        lw      a0, 0(t0)               # a0 <--- x_00
        lw      a1, 4(t0)               # a1 <--- x_01
        lw      a2, 8(t0)               # a2 <--- x_02
        lw      a3, 12(t0)              # a3 <--- x_10
        lw      a4, 16(t0)              # a4 <--- x_11
        lw      a5, 20(t0)              # a5 <--- x_12
        lw      a6, 24(t0)              # a6 <--- x_20
        lw      a7, 28(t0)              # a7 <--- x_21
        
        addi    sp, sp, -4
        lw      t0, 32(t0)              # in the stack <--- x_22
        sw      t0, 0(sp)

        jal     det_3x3
        mv      s0, a0

        la      a0, output
        addi    a7, x0, 4
        ecall
        mv      a0, s0
        addi    a7, x0, 1
        ecall

        j       exit


det_3x3:
        addi    sp, sp, -24
        sw      ra, 0(sp)
        sw      t0, 4(sp)
        sw      t1, 8(sp)
        sw      t2, 12(sp)
        sw      t3, 16(sp)
        sw      t4, 20(sp)
        lw      t0, 24(sp)              # t0 <--- 9th element of the matrix 

        mv      t1, a0                  # copy a0-3 into t1-4
        mv      t2, a1
        mv      t3, a2
        mv      t4, a3

        mv      a0, a4
        mv      a1, a5
        mv      a2, a7
        mv      a3, t0
        jal     det_2x2
        mul     t1, t1, a0              # t1 <--- x_00 * det(x_11, x_12, x_21, x_22)

        mv      a0, t4
        mv      a1, a5
        mv      a2, a6
        mv      a3, t0
        jal     det_2x2
        mul     t2, t2, a0              # t2 <--- x_01 * det(x_10, x_12, x_20, x_22)

        mv      a0, t4
        mv      a1, a4
        mv      a2, a6
        mv      a3, a7
        jal     det_2x2
        mul     t3, t3, a0              # t3 <--- x_02 * det(x_10, x_11, x_20, x_21)

        sub     t1, t1, t2
        add     a0, t1, t3

        lw      ra, 0(sp)
        lw      t0, 4(sp)
        lw      t1, 8(sp)
        lw      t2, 12(sp)
        lw      t3, 16(sp)
        lw      t4, 20(sp)
        addi    sp, sp, 24
        jr      ra


det_2x2:
        mul     a0, a0, a3
        mul     a1, a1, a2
        sub     a0, a0, a1
        jr      ra


exit:
        addi    a7, x0, 10
        ecall