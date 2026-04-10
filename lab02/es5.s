.data
a:      .byte   67
b:      .byte   69

string_a: .string "a --> "
string_b: .string "\nb --> "
string_swap: .string "\nswap\n"

.text
main:
        la      t2, a
        lb      t0, 0(t2)
        la      t2, b
        lb      t1, 0(t2)

print:
        la      a0, string_a
        addi    a7, x0, 4
        ecall
        add     a0, x0, t0
        addi    a7, x0, 1
        ecall

        la      a0, string_b
        addi    a7, x0, 4
        ecall
        add     a0, x0, t1
        addi    a7, x0, 1
        ecall

        bne     s11, x0, exit

        la      a0, string_swap
        addi    a7, x0, 4
        ecall

        xor     t0, t0, t1              # swap with xor
        xor     t1, t0, t1
        xor     t0, t0, t1

        addi    s11, x0, 1
        j       print

exit:
        addi    a7, x0, 10
        ecall