.data
buf_size: .byte 11

input:  .string "Insert a unsigned number [0 <--> 4294967295]: "
error:  .string "It's not a number.\n"
overflow: .string "The number can't be represent on 32 bits.\n"
ok:     .string "The unsigned number is: "

.bss
number: .zero   4
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
        xor     t4, t4, t4              # reset accumulator
        addi    s10, x0, 10             # s10 <-- 10 to convert the number in decimal

loop:
        beq     a0, x0, print_ok
        lb      t1, 0(a1)

        slti    t2, t1, 58              # check if is a digit
        slt     t3, s11, t1
        and     t2, t2, t3
        beq     t2, x0, print_error

        mul     t5, t4, s10
        bgt     t4, t5, print_overflow  # check overflow in the multiplication
        
        add     t4, t5, t1
        addi    t4, t4, -48

        addi    a1, a1, 1
        addi    a0, a0, -1
        j       loop

print_error:
        la      a0, error
        addi    a7, x0, 4
        ecall
        j       exit

print_overflow:
        la      a0, overflow
        addi    a7, x0, 4
        ecall
        j       exit

print_ok:
        la      a0, ok
        addi    a7, x0, 4
        ecall
        
        add     a0, t4, x0
        addi    a7, x0, 36
        ecall

exit:
        addi    a7, x0, 10
        ecall