        .equ    GPIO_BASE, 0x60004000   # Indirizzo base del registro
        .equ    GPIO_OUT_W1TS, 0x00000008 # Offset: "Write 1 To Set"
        .equ    GPIO_OUT_W1TC, 0x0000000C # Offset: "Write 1 To  clear
        .equ    GPIO_ENABLE_W1TS, 0x00000024 # Offset: abilita il pin come OUTPUT
        .equ    DELAY_CYCLES, 20000000  # Numero di iterazioni del loop di delay 
        .equ    PIN_LED, (1 << 12)

.section .text

.globl app_main

app_main:
        li      t0, GPIO_BASE
        li      t1, PIN_LED
        addi    t2, t0, GPIO_ENABLE_W1TS # configure pin in output mode
        sw      t1, 0(t2)
loop:
        addi    t2, t0, GPIO_OUT_W1TS
        sw      t1, 0(t2)

        li      a0, DELAY_CYCLES
        jal     wait

        addi    t2, t0, GPIO_OUT_W1TC
        sw      t1, 0(t2)

        li      a0, DELAY_CYCLES
        jal     wait

        j       loop

wait:
        addi    a0, a0, -1
        bnez    a0, wait
        jr      ra