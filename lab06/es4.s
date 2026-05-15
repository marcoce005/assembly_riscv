.data
mat:    .word   1, 2, 3, 4
output: .string "det(...) = "
.text
main:
        la      t0, mat
        lw      a0, 0(t0)               # a0 <--- x_00
        lw      a1, 4(t0)               # a1 <--- x_01
        lw      a2, 8(t0)               # a2 <--- x_10
        lw      a3, 12(t0)              # a3 <--- x_11

        jal     det_2x2
        mv      s0, a0

        la      a0, output
        addi    a7, x0, 4
        ecall
        mv      a0, s0
        addi    a7, x0, 1
        ecall

        j       exit


det_2x2:
        mul     a0, a0, a3
        mul     a1, a1, a2
        sub     a0, a0, a1
        jr      ra


exit:
        addi    a7, x0, 10
        ecall