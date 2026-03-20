.data
n1:     .byte   10
n2:     .byte   0b10
n3:     .byte   0x10

.bss
res:    .zero   1

.text
main:
        la      t0, n1
        lb      t1, 0(t0)
        la      t0, n2
        lb      t2, 0(t0)
        la      t0, n3
        lb      t3, 0(t0)
    
        sub     t4, t1, t2
        add     t4, t4, t3

        la      t5, res
        sb      t4, 0(t5)
    
        addi    a7, x0, 1
        add     a0, x0, t4
        ecall
    
exit:
        addi    a7, x0, 10
        ecall