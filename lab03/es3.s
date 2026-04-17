.data
buf_size: .byte 11

input:  .string "Insert a number [max 10 digit]: "
error:  .string "It's not a number\n"
correct: .string "It's a number\n"

.bss
buf:    .zero   11

.text
main:
        la      a0, input
        addi    a7, x0, 4
        ecall

        la      t0, buf_size
        lb      s0, 0(t0)               # s0 <-- buf_size

        xor     a0, a0, a0              # a0 <-- number of written bytes [upper limit during the decoding of the number]
        la      a1, buf                 # a1 <-- buffer address
        add     a2, x0, s0              # a2 <-- buffer size
        addi    a7, x0, 63
        ecall

        beq     a0, s0, read_digits     # skip the remove of newline if the buffer is full
        addi    a0, a0, -1              # remove the character newline

read_digits:
        addi    s11, s11, 47            # s11 <-- the character before '0'

loop:
        beq     a0, x0, print_ok
        lb      t1, 0(a1)

        slti    t2, t1, 58              # check if is a digit
        slt     t3, s11, t1
        and     t2, t2, t3
        beq     t2, x0, print_error

        addi    a1, a1, 1
        addi    a0, a0, -1
        j       loop

print_error:
        la      a0, error
        addi    a7, x0, 4
        ecall
        j       exit

print_ok:
        la      a0, correct
        addi    a7, x0, 4
        ecall

exit:
        addi    a7, x0, 10
        ecall