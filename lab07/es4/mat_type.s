.globl mat_type

mat_type:
        addi    sp, sp, -28
        sw      ra, 24(sp)
        sw      s3, 20(sp)
        sw      s2, 16(sp)
        sw      t1, 12(sp)
        sw      t0, 8(sp)
        sw      s1, 4(sp)
        sw      s0, 0(sp)

        mv      s0, a1                  # s0 <--- matrix dimension
        addi    s1, s0, 1               # s1 <--- matrix dimension + 1
        mv      s2, a0                  # s2 <--- copy of matrix pointer
        xor     s3, s3, s3              # s3 <--- tot sum of elements
        
        mul     t0, s0, s0
        sub     t0, t0, s0
        addi    t0, t0, -2              # t0 <-- s0^2 - s0 - 2 <--- starting point
        addi    t1, x0, 1               # t1 <--- limit for the row

loop:
        mv      a0, s2
        addi    a1, t1, 1
        mv      a2, t0
        mv      a3, t1
        mv      a4, s0

        jal     process_row
        add     s3, s3, a0

        addi    t1, t1, 1
        sub     t0, t0, s1
        bge     t0, x0, loop

        add     a0, x0, 1
        bne     s3, x0, return_mat_type
        addi    a0, a0, 1
        j       return_mat_type

not_sym:
        mv      a0, x0
return_mat_type:
        lw      ra, 24(sp)
        lw      s3, 20(sp)
        lw      s2, 16(sp)
        lw      t1, 12(sp)
        lw      t0, 8(sp)
        lw      s1, 4(sp)
        lw      s0, 0(sp)
        addi    sp, sp, 28
        jr      ra


process_row:                            # process_row(matrix pointer, dimension submatrix, starting point diagonal, starting point line [offset], dimensione matrix) return sum_elem_processed
        addi    sp, sp, -12
        sw      t2, 8(sp)
        sw      t1, 4(sp)
        sw      t0, 0(sp)

        xor     t2, t2, t2              # reset tot in t2

loop_in_row:
        add     t0, a2, a3              # t0 <--- offset for the row
        
        mul     t1, a4, a3
        add     t1, t1, t0
        sub     t1, t1, a3

        slli    t0, t0, 2               # offesets * 4 for the correct address
        slli    t1, t1, 2
        add     t0, t0, a0              # add base address [a0]
        add     t1, t1, a0

        lw      t0, 0(t0)               # symmetric numbers
        lw      t1, 0(t1)

        add     t2, t2, t0              # update tot sum
        add     t2, t2, t1

        sub     t0, t0, t1
        bne     t0, x0, skip_to_not_sym

        addi    a3, a3, -1
        bne     a3, x0, loop_in_row

return_process_row:
        mv      a0, t2
        lw      t2, 8(sp)
        lw      t1, 4(sp)
        lw      t0, 0(sp)
        addi    sp, sp, 12
        jr      ra

skip_to_not_sym:
        lw      t2, 8(sp)
        lw      t1, 4(sp)
        lw      t0, 0(sp)
        addi    sp, sp, 12
        j       not_sym