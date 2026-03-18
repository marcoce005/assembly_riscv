.data
wVar:   .word   3

.text
main:
        la      s11, wVar
        lw      t1, 0(s11)
        add     t0, x0, t1
    
exit:
        li      a7, 10
        ecall