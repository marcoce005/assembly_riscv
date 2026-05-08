.data
dim:    .byte   8
star:   .string "*"
newline: .string "\n"

.text
main:
        la      t0, dim
        lb      a0, 0(t0)

        jal     print_triangle

        la      t0, dim
        lb      a0, 0(t0)

        jal     print_square

        j       exit

print_triangle:
        xor     t1, t1, t1
        mv      t0, a0
loop_i:
        addi    t1, t1, 1
        add     a1, t1, x0

        jal     t2, print_n_stars

        bne     t1, t0, loop_i

        jr      ra

print_square:
        xor     t1, t1, t1
        mv      t0, a0
loop_j:
        addi    t1, t1, 1
        add     a1, t0, x0

        jal     t2, print_n_stars

        bne     t1, t0, loop_j

        jr      ra

print_n_stars:
        la      a0, star
        addi    a7, x0, 4
        ecall

        addi    a1, a1, -1
        bne     a1, x0, print_n_stars
        
        la      a0, newline
        addi    a7, x0, 4
        ecall

        jr      t2

exit:
        addi    a7, x0, 10
        ecall