.data
opa:    .word   2043
opb:    .word   5
input:  .string "Insert the operand\n. + --> 1\n. - --> 2\n. * --> 3\n. / --> 4\n --> "
error:  .string "Wrong input\n"

.bss
res:    .zero   4
buf:    .zero   2

.text
        j       main

print_error:
        la      a0, error
        addi    a7, x0, 4
        ecall

main:
        la      a0, input
        addi    a7, x0, 4
        ecall

        xor     a0, a0, a0
        la      a1, buf
        addi    a2, x0, 2
        addi    a7, x0, 63
        ecall

        lb      s0, 0(a1)
        addi    s0, s0, -49             # ASCII to integer

# check if the input is valid
        addi    t0, x0, 4               # upper limit of selection
        sltu    t1, s0, t0
        addi    t0, x0, -1              # lower limit of selection
        slt     t0, t0, s0
        and     t2, t0, t1
        beqz    t2, print_error

        slli    s0, s0, 2
        la      t0, table
        add     t0, t0, s0
        lw      t1, 0(t0)
        jr      t1

somma:
        addi    s11, x0, 69
        j       exit
sottrazione:
        addi    s11, x0, 67
        j       exit
prodotto:
        addi    s11, x0, 1
        j       exit
divisione:
        addi    s11, x0, 70


exit:
        addi    a7, x0, 10
        ecall

.data
table:  .word   somma, sottrazione, prodotto, divisione