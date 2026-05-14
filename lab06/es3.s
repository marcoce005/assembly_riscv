.data
n:      .word   19
output: .string "Collatz sequence from "
end_output: .string ":\n"

.text
main:
        la      t0, n
        lw      s0, 0(t0)               # a0 <--- n

        la      a0, output
        addi    a7, x0, 4
        ecall
        mv      a0, s0
        addi    a7, x0, 1
        ecall
        la      a0, end_output
        addi    a7, x0, 4
        ecall

        mv      a0, s0
        addi    s1, x0, 1               # s1 <--- 1 the lower bound
        jal     collatz_seq

        j       exit


collatz_seq:
        addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      t0, 0(sp)
        
loop:
        mv      t0, a0
        addi    a7, x0, 1
        ecall
        addi    a0, x0, 10              # a0 <--- '\n'
        addi    a7, x0, 11
        ecall

        mv      a0, t0
        jal     cal_next

        bne     a0, s1, loop

        addi    a7, x0, 1
        ecall
        lw      ra, 4(sp)
        lw      t0, 0(sp)
        addi    sp, sp, 8
        jr      ra


cal_next:
        addi    sp, sp, -4
        sw      t0, 0(sp)

        andi    t0, a0, 1
        beqz    t0, is_even

        addi    t0, x0, 3
        mul     a0, a0, t0              # a0 % 2 != 0 ---> a0 = 3 * a0 + 1
        addi    a0, a0, 1
        j       return_cal_next

is_even:
        addi    t0, x0, 2
        div     a0, a0, t0              # a0 % 2 == 0 ---> a0 = a0 / 2

return_cal_next:
        lw      t0, 0(sp)
        addi    sp, sp, 4
        jr      ra


exit:
        addi    a7, x0, 10
        ecall