.data
ora_in: .byte   12, 47
ora_out: .byte  17, 44
X:      .byte   1
Y:      .byte   40

.text
main:   la      a0, ora_in              # indirizzo di ora_in
        la      a1, ora_out             # indirizzo di ora_out
        la      t0, X
        lbu     a2, 0(t0)
        la      t0, Y
        lbu     a3, 0(t0)
        jal     costoParcheggio
        li      a7, 10
        ecall

costoParcheggio:
        addi    sp, sp, -8
        sw      t0, 4(sp)
        sw      t1, 0(sp)

        lb      t0, 0(a0)               # load hours
        lb      t1, 0(a1)

        beq     t0, t1, single_hour
        sub     t1, t1, t0              # diff minutes
        addi    t0, x0, 60
        mul     t1, t1, t0              # hours --> minutes
        j       cal_prize

single_hour:
        lb      t0, 1(a0)
        lb      t1, 1(a1)               # load minutes
        sub     t1, t1, t0              # diff minutes

cal_prize:
        div     a0, t1, a3
        rem     t1, t1, a3
        beq     t1, x0, return
        addi    a0, a0, 1

return:
        lw      t0, 4(sp)
        lw      t1, 0(sp)
        addi    sp, sp, 8
        jr      ra