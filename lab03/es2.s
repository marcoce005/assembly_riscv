.data
op1:    .word   0x0000D000
op2:    .word   0xFFFFD000

newline: .string "\n"
overflow_str: .string "overflow\n"

.text
main:
        la      t0, op1
        lw      t1, 0(t0)
        la      t0, op2
        lw      t2, 0(t0)

        xor     s11, s11, s11           # test counter
        addi    s10, x0, 1

        mul     s0, t1,t1
        mulh    s1, t1, t1

        srli    t3, t1, 31
        srli    t4, t1, 31
        srli    t5, s0, 31
        xor     t6, t3, t4
        bne     t6, t5, overflow        # check overflow if the result signed is different from the hypotetical signed
        add     a0, x0, s0
        addi    a7, x0, 1
        ecall
        la      a0, newline
        addi    a7, x0, 4
        ecall

test2:
        mul     s0, t2, t2
        mulh    s1, t2, t2

        addi    s11, s11, 1             # increase test counter

        srli    t3, t2, 31
        srli    t4, t2, 31
        srli    t5, s0, 31
        xor     t6, t3, t4
        bne     t6, t5, overflow
        add     a0, x0, s0
        addi    a7, x0, 1
        ecall
        la      a0, newline
        addi    a7, x0, 4
        ecall

test3:
        mul     s0, t1, t2
        mulh    s1, t1, t2

        addi    s11, s11, 1

        srli    t3, t1, 31
        srli    t4, t2, 31
        srli    t5, s0, 31
        xor     t6, t3, t4
        bne     t6, t5, overflow
        add     a0, x0, s0
        addi    a7, x0, 1
        ecall
        la      a0, newline
        addi    a7, x0, 4
        ecall

        j       exit

overflow:
        la      a0, overflow_str
        addi    a7, x0, 4
        ecall

        beq     s11, x0, test2
        beq     s11, s10, test3

exit:
        addi    a7, x0, 10
        ecall