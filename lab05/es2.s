.data
star:   .string "*"
newline: .string "\n"
input:  .string "Insert base dimesion [max 10 digit]: "
error:  .string "Invalid digit\n"

.bss
buf:    .zero   12

.text
main:
        jal     get_input
        mv      s0, a0

        mv      a0, s0
        jal     print_triangle

        mv      a0, s0
        jal     print_square

        j       exit

error_digit:
        la      a0, error
        addi    a7, x0, 4
        ecall
get_input:
        la      a0, input
        addi    a7, x0, 4
        ecall

        xor     a0, a0, a0
        addi    a2, x0, 12
        addi    a7, x0, 63
        la      a1, buf
        ecall

        slti    t0, a0, 2
        bne     t0, x0, error_digit

        addi    t1, x0, 11
        xor     t0, t0, t0              # t0 accumulator
        addi    t2, x0, 10              # t2 <-- 10
        addi    t6, x0, 47              # t6 <--- 47 
        addi    a0, a0, -1
        ble     a0, t1, convert_digits
        addi    a0, x0, 10
convert_digits:
        beqz    a0, save_num

        lb      t1, 0(a1)
        slti    t3, t1, 58              # check if is a digiti
        slt     t4, t6, t1
        and     t3, t3, t4

        beq     t3, x0, error_digit

        mul     t0, t0, t2
        addi    t1, t1, -48
        add     t0, t0, t1

        addi    a1, a1, 1
        addi    a0, a0, -1
        j       convert_digits
save_num:
        mv      a0,t0
        jr      ra

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