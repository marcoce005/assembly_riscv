.data
len:    .word   10
x:      .word   1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.bss
mat:    .zero   400

.text
main:
        la      t0, len
        lw      t1, 0(t0)               # array len in t1
        mv      t0, t1                  # couter for x loop in t0
        la      s0, x                   # address of vet x
        la      s1, mat                 # address of mat x * y        

loop_x:
        beqz    t0, exit

        lw      a0, 0(s0)
        jal     create_row

        addi    s0, s0, 4
        addi    t0, t0, -1
        j       loop_x

create_row:
        mv      t3, t1                  # counter for y loop in t3
        la      s2, x                   # address of y in s2

loop_y:
        beqz    t3, end

        lw      t4, 0(s2)
        mul     t4, a0, t4
        sw      t4, 0(s1)

        addi    s1, s1, 4
        addi    s2, s2, 4
        addi    t3, t3, -1
        j       loop_y
end:
        jr      ra

exit:
        addi    a7, x0, 10
        ecall