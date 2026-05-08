.data
buf_size: .word 256
input:  .string "Insert a string: "
output: .string "Converted string: "

.bss
buf:    .zero   256

.text
main:
        la      a0, input
        addi    a7, x0, 4
        ecall

        xor     a0, a0, a0
        la      a1, buf
        la      t0, buf_size
        lw      a2, 0(t0)
        addi    a7, x0, 63
        ecall

        addi    s0, x0, 96              # character before 'a' lower limit
        addi    s1, x0, 123             # character after 'z' upper limit

        mv      s2, a1                  # s2 <--- copy of buffer address
        mv      s3, a0                  # s3 <--- numer of read bytes
loop:
        beqz    s3, print
        
        lb      a0, 0(a1)
        jal     to_upper
        sb      a0, 0(a1)

        addi    a1, a1, 1
        addi    s3, s3, -1
        j       loop

print:
        la      a0, output
        addi    a7, x0, 4
        ecall

        mv      a0, s2
        addi    a7, x0, 4
        ecall
        j       exit

to_upper:
        slt     t0, a0, s1
        slt     t1, s0, a0
        and     t0, t1, t0
        beqz    t0, skip

        addi    a0, a0, -32
skip:
        jr      ra

exit:
        addi    a7, x0, 10
        ecall