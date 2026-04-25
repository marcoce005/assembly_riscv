.data
row:    .word   4
col:    .word   6
mat:    .word   154, 123, 109, 86, 4, 0, 412, -23, -231, 9, 50, 0, 123, -24, 12, 55, -45, 0, 0, 0, 0, 0, 0, 0

.text
main:
        la      s0, mat                 # s0 <-- mat address
        la      t0, row
        lw      s1, 0(t0)               # s1 <-- row
        la      t0, col
        lw      s2, 0(t0)               # s2 <-- col

        slli    s3, s2, 2               # s3 <-- col * 4 byte = to increment the row

        mv      s4, s2                  # set counter s4 with n_col s2
        mv      s5, s0                  # copy of address mat in s5

loop_col:
        mv      a0, s5
        jal     sum_col                 # sum col from address t1 / a0 [function argument]        
        sw      t0, 0(a0)

        addi    s5, s5, 4               # next column
        addi    s4, s4, -1
        bne     s4, x0, loop_col

        mv      s4, s1                  # set counter s4 with n_col s1
        mv      s5, s0                  # copy of address mat in s5

loop_row:
        mv      a0, s5
        jal     sum_row
        sw      t0, 0(a0)
        
        add     s5, s5, s3
        addi    s4, s4, -1
        bne     s4, x0, loop_row
        
        j       exit

sum_col:
        xor     t0, t0, t0              # counter t0
        addi    t1, s1, -1              # t1 upper limits [n_row - 1]
        
loop_i:
        lw      t2, 0(a0)
        add     t0, t0, t2
        add     a0, a0, s3
        addi    t1, t1, -1
        
        bne     t1, x0, loop_i
        jr      ra


sum_row:
        xor     t0, t0, t0              # counter t0
        addi    t1, s2, -1              # t1 upper limits [n_col - 1]
        
loop_j:
        lw      t2, 0(a0)
        add     t0, t0, t2
        addi    a0, a0, 4
        addi    t1, t1, -1
        
        bne     t1, x0, loop_j
        jr      ra


exit:
        addi    a7, x0, 10
        ecall