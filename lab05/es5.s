.data
n:      .word   12
k:      .word   2
n_equal: .string "n = "
k_equal: .string "\nk = "
output: .string "\nC(n, k) = "

.text
main:
        la      t0, n
        lw      s0, 0(t0)               # s0 <--- n
        la      t0, k
        lw      s1, 0(t0)               # s0 <--- k

        la      a0, n_equal
        addi    a7, x0, 4
        ecall
        mv      a0, s0
        addi    a7, x0, 1
        ecall

        la      a0,k_equal
        addi    a7, x0, 4
        ecall
        mv      a0, s1
        addi    a7, x0, 1
        ecall

        mv      a0, s0
        mv      a1, s1
        jal     comb

        mv      s2, a0

        la      a0,output
        addi    a7, x0, 4
        ecall

        mv      a0, s2
        addi    a7, x0, 1
        ecall

        j       exit

comb:
        mv      t0, a0
        mv      t1, a1

        jal     t6, fact
        mv      t2, a0                  # t2 <-- n!

        mv      a0, t1
        jal     t6, fact
        mv      t3, a0                  # t3 <--- k!

        div     t2, t2, t3              # t2 = n! / k!

        sub     a0, t0, t1              # a0 = n - k
        jal     t6, fact
        mv      t3, a0                  # t3 <--- (n - k)!

        div     t2, t2, t3              # t2 = n! / (n - k)! * k!

        mv      a0, t2
        jr      ra


fact:
        addi    t4, x0, 1               # t0 <--- tot for the factorial
loop:
        mul     t4, t4, a0
        addi    a0, a0, -1
        bne     a0, x0, loop
        mv      a0, t4
        jr      t6

exit:
        addi    a7, x0, 10
        ecall