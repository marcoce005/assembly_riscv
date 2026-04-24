.data
num:    .half   1970
output: .string "Numbers of 1: "

.text
main:
        la      t0, num
        lh      s0, 0(t0)               # s0 <-- num

        addi    t0, x0, 16              # set upper limits
        xor     t1, t1, t1              # reset counter

loop:
        beqz    t0, print
        
        andi    t2, s0, 1
        add     t1, t1, t2
        srli    s0, s0, 1

        addi    t0, t0, -1
        j       loop

print:
        la      a0, output
        addi    a7, x0, 4
        ecall
        add     a0, x0, t1
        addi    a7, x0, 1
        ecall

exit:
        addi    a7, x0, 10
        ecall