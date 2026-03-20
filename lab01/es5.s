.data
a:      .word   7
b:      .word   11
c:      .word   1
space:  .string " - "
arrow:  .string "    -->    "

.text
main:
        la      t0, a
        lw      t1, 0(t0)
        la      t0, b
        lw      t2, 0(t0)
        la      t0, c
        lw      t3, 0(t0)
        
        xor     s0, s0, s0
        j       print
        
sort:
        addi    s0, x0, 1               # flag to not print the arrow again
        
        ble     t1, t2, a_b_ok
        xor     t1, t1, t2
        xor     t2, t1, t2
        xor     t1, t1, t2
        
a_b_ok:
        ble     t1, t3, a_c_ok
        xor     t1, t1, t3
        xor     t3, t1, t3
        xor     t1, t1, t3
    
a_c_ok:
        ble     t2, t3, print
        xor     t2, t2, t3
        xor     t3, t2, t3
        xor     t2, t2, t3
    
print:
        addi    a7, x0, 1
        add     a0, x0, t1
        ecall
        la      a0, space
        addi    a7, x0, 4
        ecall
        
        addi    a7, x0, 1
        add     a0, x0, t2
        ecall
        la      a0, space
        addi    a7, x0, 4
        ecall
        
        addi    a7, x0, 1
        add     a0, x0, t3
        ecall
        
        bne     s0, x0, exit            # skip arrow the second time
        
        la      a0, arrow               # print arrow
        addi    a7, x0, 4
        ecall
                
        j       sort                    # go to order numbers [only the first time]

exit:
        addi    a7, x0, 10
        ecall