.data
wOpd1:  .word   10
wOpd2:  .word   24

.bss
wResult: .zero  4

.text
main:
        lw      t1, wOpd1
        lw      t2, wOpd2
        la      s11, wResult
        add     t0, t1, t2
        sw      t0, 0(s11)
    
exit:
        addi    a7, x0, 10
        ecall