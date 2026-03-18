.data
wVett:  .word   5, 7, 3, 4, 3

.bss
wResult: .zero  4

.text
main:
        add     t1, x0, x0
        la      t0, wVett
        la      s11, wResult
        
        lw      t2, 0(t0)
        add     t1, t1, t2
        
        lw      t2, 4(t0)
        add     t1, t1, t2
        
        lw      t2, 8(t0)
        add     t1, t1, t2
        
        lw      t2, 12(t0)
        add     t1, t1, t2
        
        lw      t2, 16(t0)
        add     t1, t1, t2
        
        sw      t1, 0(s11)
    
exit:
        addi    a7, x0, 10
        ecall