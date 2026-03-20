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
        bleu    t4, t1, print_error
        
        add     t4, t4, t3              # overflow
        bleu    t4, t3, print_error
        
        add     a0, x0, t4
        addi    a7, x0, 36
        ecall
        j       exit
        
print_error:
        la      s0, error               # s0 address to string error
        add     a0, x0, s0
        addi    a7, x0, 4
        ecall
    
exit:
        addi    a7, x0, 10
        ecall