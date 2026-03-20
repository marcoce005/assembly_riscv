.data
op1:    .byte   150
op2:    .byte   100
newline: .string "\n"

.text
main:
        la      t0, op1
        lb      t1, 0(t0)               # default signed
        la      t0, op2
        lb      t2, 0(t0)
        
        add     t3, t1, t2
        
        add     a0, x0, t3
        addi    a7, x0, 1
        ecall

        la      s1, newline
        add     a0, x0, s1
        addi    a7, x0, 4
        ecall
        
        la      t0, op1
        lbu     t1, 0(t0)               # forcing unsigned
        la      t0, op2
        lb      t2, 0(t0)
        
        add     t3, t1, t2
        
        add     a0, x0, t3
        addi    a7, x0, 1
        ecall
    
exit:
        addi    a7, x0, 10
        ecall