.data
num:    .word   141592653
base:   .word   33
default_base: .string "(10)"
arrow:  .string " --> "

.text
main:
        la      t0, num
        lw      s0, 0(t0)               # s0 <--- num
        la      t0, base
        lw      s1, 0(t0)               # s1 <--- base
        xor     s3, s3, s3              # s3 <--- number division counter
        addi    s4, x0, 57              #s4 <--- '9'

        mv      a0, s0
        addi    a7, x0, 1
        ecall
        la      a0, default_base
        addi    a7, x0, 4
        ecall
        la      a0, arrow
        addi    a7, x0, 4
        ecall

decompone:
        beqz    s0, extract_from_stack

        remu    t0, s0, s1
        addi    sp, sp, -4
        sw      t0, 0(sp)

        addi    s3, s3, 1
        divu    s0, s0, s1
        j       decompone

extract_from_stack:
        lw      t0, 0(sp)
        addi    sp, sp, 4
        addi    t0, t0, 48

        ble     t0, s4, print_char
        addi    t0, t0, 7
print_char:
        mv      a0, t0
        addi    a7, x0, 11
        ecall

        addi    s3, s3, -1
        bnez    s3, extract_from_stack

        addi    a0, x0, 40              # a0 <--- '('
        addi    a7, x0, 11
        ecall
        mv      a0, s1
        addi    a7, x0, 1
        ecall
        addi    a0, x0, 41              # a0 <--- ')'
        addi    a7, x0, 11
        ecall

exit:
        addi    a7, x0, 10
        ecall