        .equ    GPIO_BASE, 0x60004000   # base address of the register
        .equ    GPIO_OUT_W1TS, 0x08     # Offset: "Write 1 To Set"
        .equ    GPIO_OUT_W1TC, 0x0C     # Offset: "Write 1 To  clear
        .equ    GPIO_ENABLE_W1TS, 0x24  # Offset: enable pin as OUTPUT
        .equ    GPIO_OUT_REG, 0x04      # offset: read register status

        .equ    GPIO6, (1 << 6)
        .equ    GPIO7, (1 << 7)
        .equ    LED, (1 << 12)

        .equ    X_LIMITS, 3000000
        .equ    Y_LIMITS, 5000000
        .equ    Z_LIMITS, 300000

.section .text

.globl app_main

app_main:
        li      s0, GPIO_BASE
        
        li      s1, X_LIMITS
        li      s2, Y_LIMITS
        li      s3, Z_LIMITS
        
        li      s4, GPIO6
        li      s5, GPIO7
        li      s6, LED

        addi    t0, s0, GPIO_ENABLE_W1TS # address to enable output mode
        or      t1, s4, s5
        or      t1, t1, s6              # 1 on GPIO6, GPIO7 and LEDimm
        sw      t1, 0(t0)               # output mode GPIO6, GPIO7, LED [GPIO12]

        xor     s11, s11, s11           # reset counter cycles

loop:
        addi    s11, s11, 1

        li      t0, X_LIMITS            # check if we have made X iterations
        rem     t0, s11, t0
        bnez    t0, check_Y
        
        lw      t0, GPIO_OUT_REG(s0)    # read output regs
        andi    t0, t0, GPIO6           # isolated status of GPIO6
        beqz    t0, enable_GPIO6

        sw      s4, GPIO_OUT_W1TC(s0)   # disable GPIO6
        j       check_Y

enable_GPIO6:
        sw      s4, GPIO_OUT_W1TS(s0)   # disable GPIO6

check_Y:
        li      t0, Y_LIMITS
        rem     t0, s11, t0
        bnez    t0, check_Z

        lw      t0, GPIO_OUT_REG(s0)    # read output regs
        andi    t0, t0, GPIO7           # isolated status of GPIO7
        beqz    t0, enable_GPIO7

        sw      s5, GPIO_OUT_W1TC(s0)   # disable GPIO7
        j       check_Z

enable_GPIO7:
        sw      s5, GPIO_OUT_W1TS(s0)   # disable GPIO7

check_Z:
        li      t0, Z_LIMITS
        rem     t0, s11, t0
        bnez    t0, loop
        
        lw      t0, GPIO_OUT_REG(s0)    # read output regs
        
        andi    t1, t0, (GPIO6 | GPIO7)
        srli    t1, t1, 6               # status of GPIO6 and GPIO7 in the first 2 bit LSB

        beqz    t1, power_off_LED       # GPIO6 == GPIO7 == 0

        li      t2, 0b10
        bne     t1, t2, power_on_LED    # GPIO6 == 0 && GPIO7 == 1

        and     t1, t0, s6              # filter with the LED
        beqz    t1, power_on_LED
        j       power_off_LED

power_on_LED:
        sw      s6, GPIO_OUT_W1TS(s0)
        j       loop

power_off_LED:
        sw      s6, GPIO_OUT_W1TC(s0)
        j       loop