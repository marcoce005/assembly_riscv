.data
input:  .string "Insert a char: "

.bss
buf:    .byte   2

.text
main:
        la      a0, input
        addi    a7, x0, 4
        ecall

        xor     a0, a0, a0
        la      a1, buf
        addi    a2, x0, 2
        addi    a7, x0, 63
        ecall
        lb      t0, 0(a1)               # char0 --> t0

        la      a0, input
        addi    a7, x0, 4
        ecall

        xor     a0, a0, a0
        la      a1, buf
        addi    a2, x0, 2
        addi    a7, x0, 63
        ecall
        lb      t1, 0(a1)               # char1 --> t1

        andi    t0, t0, 0xFF            # clean t0
        andi    t1, t1, 0xFF            # clean t1

        not     t2, t1
        and     t2, t0, t2
        not     t2, t2
        xor     t3, t0, t1
        or      t2, t2, t3

        andi    t2, t2, 0xFF            # clean t1

        add     a0, x0, t2
        addi    a7, x0, 35
        ecall

exit:
        addi    a7, x0, 10
        ecall