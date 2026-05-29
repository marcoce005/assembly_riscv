        .equ    DIM, 5

.data
vet1:   .word   56, 12, 98, 129, 58
vet2:   .word   1, 0, 245, 129, 12
risultato: .zero DIM

.text
main:
        la      a0, vet1
        la      a1, vet2
        la      a2, risultato
        li      a3, DIM
        jal     DistanzaHamming
        li      a7, 10
        ecall

DistanzaHamming:
        addi    sp, sp, -16
        sw      t6, 12(sp)
        sw      t2, 8(sp)
        sw      t1, 4(sp)
        sw      t0, 0(sp)

loop:
        lw      t0, 0(a0)
        lw      t1, 0(a1)
        addi    t6, x0, 32
        xor     t0, t0, t1              # different bits between t0 and t1
        xor     t2, t2, t2              # reset counter diff bit

all_bits:
        andi    t1, t0, 1
        add     t2, t2, t1
        srli    t0, t0, 1
        addi    t6, t6, -1
        bne     t6, x0, all_bits

        sw      t2, 0(a2)

        addi    a0, a0, 4
        addi    a1, a1, 4
        addi    a2, a2, 4
        addi    a3, a3, -1
        bne     a3, x0, loop

        lw      t6, 12(sp)
        lw      t2, 8(sp)
        lw      t1, 4(sp)
        lw      t0, 0(sp)
        addi    sp, sp, 16
        jr      ra