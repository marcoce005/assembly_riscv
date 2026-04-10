.data
op1:    .word   0x01234567
op2:    .word   0x00C0FFEE
op3:    .word   0xBAADF00D
op4:    .word   0xFEEDFACE

equal:  .string "equal\n"
nequal: .string "not equal\n"

.text
main:
        la      t0, op1
        lw      s0, 0(t0)               # s0 <-- op1
        la      t0, op2
        lw      s1, 0(t0)               # s1 <-- op2
        la      t0, op3
        lw      s2, 0(t0)               # s2 <-- op3
        la      t0, op4
        lw      s3, 0(t0)               # s3 <-- op4
        addi    s4, x0, 2               # s4 <-- 2
        addi    s5, x0, 1               # s5 <-- 1

        xor     s11, s11, s11           # reset counter
        addi    t2, x0, 1
        addi    t3, x0, 2

        div     t0, s0, s4
        sra    t1, s0, s5
        j       print
test0:
        addi    s11, s11, 1
        div     t0, s1, s4
        sra    t1, s1, s5
        j       print
test1:
        addi    s11, s11, 1
        div     t0, s2, s4
        sra    t1, s2, s5
        j       print
test2:
        addi    s11, s11, 1
        div     t0, s3, s4
        sra    t1, s3, s5
        j       print


print:
        bne     t0, t1, neq
        la      a0, equal
        addi    a7, x0, 4
        ecall
        j       return
neq:
        la      a0, nequal
        addi    a7, x0, 4
        ecall
return:
        beq     s11, x0, test0
        beq     s11, t2, test1
        beq     s11,t3, test2


exit:
        addi    a7, x0, 10
        ecall