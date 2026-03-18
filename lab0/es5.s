.data
wVett:  .word   2, 5, 16, 12, 34, 7, 20, 11, 31, 44, 70, 69, 2, 4, 23

.bss
wResult: .zero  4

.text
main:
        la    t0, wVett
        la    s11, wResult
        addi    s1, x0, 60
        add    t1, x0, x0
        add    t3, x0, x0
        
loop:
        lw    t2, 0(t0)
        add    t1, t1, t2
        addi    t3, t3, 4
        addi    t0, t0, 4
        bne    t3, s1, loop
        
        sw    t1, 0(s11)   
exit:
        addi    a7, x0, 10
        ecall