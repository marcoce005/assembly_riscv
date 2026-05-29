        .equ    NUM, 5
        .equ    DIM, NUM*4
        .equ    SCONTO, 30
        .equ    ARROTONDA, 0

.data
prezzi: .word   39, 1880, 2394, 1000, 1590
scontati: .zero DIM

.text
main:
        la      a0, prezzi
        la      a1, scontati
        li      a2, NUM
        li      a3, SCONTO
        li      a4, ARROTONDA
        jal     calcola_sconto
        li      a7, 10
        ecall

calcola_sconto:
        addi    sp, sp, -28
        sw      t6, 24(sp)
        sw      t5, 20(sp)
        sw      t4, 16(sp)
        sw      t3, 12(sp)
        sw      t2, 8(sp)
        sw      t1, 4(sp)
        sw      t0, 0(sp)

        xor     t4, t4, t4              # reset sum
        addi    t1, x0, 100
        addi    t6, t6, 50
loop:
        lw      t0, 0(a0)               # t0 <--- prize
        mul     t2, t0, a3
        div     t3, t2, t1
        rem     t5, t2, t1
        
        beq     t5, x0, skip
        beq     a4, x0, inc_sconto
        blt     t5, t6, skip

inc_sconto:
        addi    t3, t3, 1

skip:
        mv      t2, t3
        sub     t2, t0, t2
        sub     t3, t0, t2
        add     t4, t4, t3
        sw      t2, 0(a1)

        addi    a0, a0, 4
        addi    a1, a1, 4
        addi    a2, a2, -1
        bne     a2, x0, loop

        mv      a0, t4
        lw      t6, 16(sp)
        lw      t5, 16(sp)
        lw      t4, 16(sp)
        lw      t3, 12(sp)
        lw      t2, 8(sp)
        lw      t1, 4(sp)
        lw      t0, 0(sp)
        addi    sp, sp, -28
        jr      ra