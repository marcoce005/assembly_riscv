.data
opa:    .word   2043
opb:    .word   5
input:  .string "Insert the operand\n. + --> 1\n. - --> 2\n. * --> 3\n. / --> 4\n --> "
error:  .string "Wrong input\n"
plus:   .string " + "
minus:  .string " - "
prod:   .string " * "
divis:  .string " / "
equal:  .string " = "

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

        la      t0, opa
        lw      s1, 0(t0)               # s1 <-- opa
        la      t0, opb
        lw      s2, 0(t0)               # s2 <-- opb
        la      s3, res

        mv      a0, s1                  # print first number
        addi    a7, x0, 1
        ecall

# switch case using array of cases
        slli    s0, s0, 2
        la      t0, table
        add     t0, t0, s0
        lw      t1, 0(t0)
        jr      t1

somma:
        add     s4, s1, s2
        la      a0, plus
        addi    a7, x0, 4
        ecall
        j       print
sottrazione:
        sub     s4, s1, s2
        la      a0, minus
        addi    a7, x0, 4
        ecall
        j       print
prodotto:
        mul     s4, s1, s2
        la      a0, prod
        addi    a7, x0, 4
        ecall
        j       print
divisione:
        div     s4, s1, s2
        la      a0, divis
        addi    a7, x0, 4
        ecall

print:
        sw      s4, 0(s3)
        
        mv      a0, s2
        addi    a7, x0, 1
        ecall
        la      a0, equal
        addi    a7, x0, 4
        ecall
        mv      a0, s4
        addi    a7, x0, 1
        ecall

exit:
        addi    a7, x0, 10
        ecall

.data
table:  .word   somma, sottrazione, prodotto, divisione