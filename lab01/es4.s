.data
op1:    .word   0x40000000
op2:    .word   0x50000000
op3:    .word   0x70000000

error:  .string "\nOverflow\n"

.text
main:
        la      t0, op1
        lw      t1, 0(t0)
        la      t0, op2
        lw      t2, 0(t0)
        la      t0, op3
        lw      t3, 0(t0)
        
        add     t4, t1, t2
        
# check overflow
        srli    s1, t1, 31              # signs of t1, t2, t3, t4
        srli    s2, t2, 31
        srli    s3, t3, 31
        srli    s4, t4, 31
        
        xor     s5, s1, s2              # check if t1 and t2 have the same sign (s1, s2)
        not     s5, s5
        andi    s5, s5, 1
        
        beq     s5, x0, second_sum            # if t1 and t2 have a different sign --> overflow is impossible --> skip
        bne     s4, s1, print_error     # result sign is != sign t1 or t2 that are the same
 
second_sum:
        add     t5, t4, t3

# check overflow
        srli    s5, t5, 31
        xor     s6, s3, s4              # check if t3 and t4 have the same sign (s3, s4)
        not     s6, s6
        andi    s6, s6, 1
        
        beq     s6, x0, print_sum
        bne     s5, s3, print_error
        
print_sum:
        add     a0, x0, t5
        addi    a7, x0, 1
        ecall
        j       exit
        
print_error:
        la      a0, error               # s0 address to string error
        addi    a7, x0, 4
        ecall
    
exit:
        addi    a7, x0, 10
        ecall