.data
number: .byte   67

odd:    .string "odd\n"
even:   .string "even\n"
arrow:  .string " --> "

.text
main:
        addi    s0, x0, 2               # s0 <-- 2
        la      t0, number              # load number in s1
        lb      s1, 0(t0)

        remu    t0, s1, s0

        j       print

method2:
        bne     t6, x0, exit
        
        andi    t0, s1, 1

        addi    t6, x0, 1               # flag to finish
        j       print

print:
        add     a0, x0, s1
        addi    a7, x0, 1
        ecall

        la      a0, arrow
        addi    a7, x0, 4
        ecall

        beq     t0, x0, print_even
        
        la      a0, odd
        addi    a7, x0, 4
        ecall
        j       method2

print_even:
        la      a0,even
        addi    a7, x0, 4
        ecall
        j       method2

exit:
        addi    a7, x0, 10
        ecall