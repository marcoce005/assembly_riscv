.data
buf_size: .byte 12

input:  .string "Insert a signed number [-2147483648 <--> +2147483647]: "
error:  .string "It's not a number.\n"
overflow: .string "The number can't be represent on 32 bits.\n"
ok:     .string "The signed number is: "

.bss
number: .zero   4
buf:    .zero   12

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

        bgt     a0, s0, read_digits     # skip the remove of newline if the buffer is full
        addi    a0, a0, -1              # remove the character newline

read_digits:
        addi    s11, s11, 47            # s11 <-- the character before '0'
        xor     t4, t4, t4              # reset accumulator
        addi    s10, x0, 10             # s10 <-- 10 to convert the number in decimal
        addi    s9, x0, 43              # s9 <-- '+' character
        addi    s8, x0, 45              # s8 <-- '-' character

        lb      t1, 0(a1)
        addi    a1, a1, 1
        addi    a0, a0, -1

        beq     t1, s9, positive
        beq     t1, s8, negative
        
        addi    a1, a1, -1              # restore the read digit
        addi    a0, a0, 1

        slti    t2, t1, 58              # check if is a digit [without sign assuming is positive]
        slt     t3, s11, t1
        and     t2, t2, t3
        bne     t2, x0, positive
        j       print_error             # automaticcaly is a non valid character

positive:
        addi    s7, x0, 1               # set the sign in s7 [1 --> positive, -1 --> negative]
        srli    s1, s7, 31
        j       loop

negative:
        addi    s7, x0, -1              # set the sign in s7 [1 --> positive, -1 --> negative]
        srli    s1, s7, 31

loop:
        beq     a0, x0, print_ok
        lb      t1, 0(a1)

        slti    t2, t1, 58              # check if is a digit
        slt     t3, s11, t1
        and     t2, t2, t3
        beq     t2, x0, print_error

        
        mul     t5, t4, s10             # accumulator * 10
        addi    t1, t1, -48             # convert in integer from ASCII
        mul     t1,t1, s7               # change sign of the qty that we add to the accumulator
        add     t5, t5, t1
        srli    s2, t5, 31              # extract sign of number after [if it's differente from the starting sign [loaded in s1] => overflow]

        bne     s1, s2, print_overflow  # check overflow
        add     t4, t5, x0

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
        la      t0, number
        sw      t4, 0(t0)

        la      a0, ok
        addi    a7, x0, 4
        ecall
        
        add     a0, t4, x0
        addi    a7, x0, 1
        ecall

exit:
        addi    a7, x0, 10
        ecall