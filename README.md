# RISC-V RV32 Assembly — Cheatsheet

> **How to read this document**
> - `rd` = destination register (where the result is written)
> - `rs1`, `rs2` = source registers (inputs)
> - `imm` = immediate value (a constant number encoded directly in the instruction)
> - `shamt` = shift amount (how many bit positions to shift, 0–31)
> - `M[addr]` = memory at address `addr`
> - `pc` = program counter (address of the current instruction)
> - `label` = a symbolic name for a memory address, defined in your code

---

## Registers

Every RISC-V instruction operates on registers, not directly on memory.
There are 32 general-purpose registers (`x0`–`x31`), each 32 bits wide.

**Caller-saved** = the calling function must save these before making a call if it still needs them.  
**Callee-saved** = the called function must restore these before returning.

| Register  | ABI Name  | Role                               | Saved by | Notes |
|-----------|-----------|------------------------------------|----------|-------|
| `x0`      | `zero`    | Always zero                        | —        | Writing to it is silently discarded. Useful as a "don't care" destination. |
| `x1`      | `ra`      | Return address                     | Caller   | `jal` stores `pc+4` here so the function knows where to return. |
| `x2`      | `sp`      | Stack pointer                      | Callee   | Points to the top of the stack. Decrement to allocate, increment to free. |
| `x3`      | `gp`      | Global pointer                     | —        | Points near global/static data; used by the linker for relaxation. |
| `x4`      | `tp`      | Thread pointer                     | —        | Points to thread-local storage. Rarely touched in simple programs. |
| `x5–x7`   | `t0–t2`   | Temporaries                        | Caller   | Free scratch registers; no guarantee they survive a function call. |
| `x8`      | `s0 / fp` | Saved reg / Frame pointer          | Callee   | Often used to anchor the stack frame for debuggers. |
| `x9`      | `s1`      | Saved register                     | Callee   | Preserved across calls; safe to use for long-lived values. |
| `x10–x11` | `a0–a1`   | Arg 1–2 / Return values            | Caller   | First two function arguments; `a0` also carries the return value. |
| `x12–x17` | `a2–a7`   | Arguments 3–8                      | Caller   | Additional function arguments; `a7` is used for ecall service number. |
| `x18–x27` | `s2–s11`  | Saved registers                    | Callee   | Preserved across calls; useful for loop counters or long computations. |
| `x28–x31` | `t3–t6`   | Temporaries                        | Caller   | Same as `t0–t2`: scratch only. |
| `pc`      | —         | Program counter                    | —        | Address of the instruction currently executing. Not directly writable. |

---

## Instruction Formats

RISC-V encodes every instruction in exactly **32 bits**. The bit layout determines
how the operands and the immediate value are packed:

```
R-type:  [ funct7(7) | rs2(5) | rs1(5) | funct3(3) | rd(5)  | opcode(7) ]
         Used for register-register operations (add, sub, and, …)

I-type:  [ imm[11:0](12)      | rs1(5) | funct3(3) | rd(5)  | opcode(7) ]
         Used for immediate operations, loads, jalr

S-type:  [ imm[11:5](7) | rs2(5) | rs1(5) | funct3(3) | imm[4:0](5) | opcode(7) ]
         Used for stores (the immediate is the address offset)

B-type:  [ imm[12|10:5](7) | rs2(5) | rs1(5) | funct3(3) | imm[4:1|11](5) | opcode(7) ]
         Used for conditional branches (target offset from pc, in bytes)

U-type:  [ imm[31:12](20)                             | rd(5)  | opcode(7) ]
         Used for lui / auipc (loads a 20-bit upper immediate)

J-type:  [ imm[20|10:1|11|19:12](20)                  | rd(5)  | opcode(7) ]
         Used for jal (21-bit signed offset from pc, LSB always 0)
```

> **Sign extension**: all immediates are sign-extended to 32 bits before use,
> meaning a negative immediate (bit 11 = 1) fills the upper bits with 1s.

---

## Arithmetic & Logic (R-type)

These instructions read two registers, compute a result, and write it to `rd`.
They never access memory and never use an immediate value.

| Instruction | Syntax              | Operation                           | Description |
|-------------|---------------------|-------------------------------------|-------------|
| `add`       | `add  rd, rs1, rs2` | `rd = rs1 + rs2`                    | Integer addition. Overflow wraps silently (no exception). |
| `sub`       | `sub  rd, rs1, rs2` | `rd = rs1 - rs2`                    | Integer subtraction. Same wrap-around behaviour. |
| `and`       | `and  rd, rs1, rs2` | `rd = rs1 & rs2`                    | Bitwise AND. Useful for masking bits (e.g. extract low byte). |
| `or`        | `or   rd, rs1, rs2` | `rd = rs1 \| rs2`                   | Bitwise OR. Useful for setting specific bits. |
| `xor`       | `xor  rd, rs1, rs2` | `rd = rs1 ^ rs2`                    | Bitwise XOR. `xor rd, rs, rs` zeroes `rd`; also used to toggle bits. |
| `sll`       | `sll  rd, rs1, rs2` | `rd = rs1 << rs2`                   | Shift Left Logical: moves bits toward MSB, fills with 0s. Equivalent to multiplying by 2^rs2. |
| `srl`       | `srl  rd, rs1, rs2` | `rd = rs1 >> rs2` (logical)         | Shift Right Logical: fills vacated bits with 0s. Treats the value as unsigned. |
| `sra`       | `sra  rd, rs1, rs2` | `rd = rs1 >> rs2` (arithmetic)      | Shift Right Arithmetic: fills with the sign bit (MSB). Preserves the sign for signed integers. Equivalent to dividing by 2^rs2 for positive numbers. |
| `slt`       | `slt  rd, rs1, rs2` | `rd = (rs1 < rs2) ? 1 : 0`         | Set Less Than (signed). Writes 1 if `rs1 < rs2`, else 0. Treats both as two's complement. |
| `sltu`      | `sltu rd, rs1, rs2` | `rd = (rs1 < rs2) ? 1 : 0`         | Set Less Than Unsigned. Same, but both values are treated as unsigned integers. |

---

## Immediate Instructions (I-type)

Same as R-type arithmetic, but the second operand is a **constant** embedded in the
instruction (12-bit signed, range −2048 to +2047) instead of a register.

| Instruction | Syntax                  | Operation                            | Description |
|-------------|-------------------------|--------------------------------------|-------------|
| `addi`      | `addi  rd, rs1, imm`    | `rd = rs1 + imm`                     | Add immediate. `addi rd, x0, imm` is the standard way to load a small constant. `addi rd, rs, 0` copies a register (see `mv` pseudo). |
| `andi`      | `andi  rd, rs1, imm`    | `rd = rs1 & imm`                     | AND immediate. Common for masking: `andi t0, t0, 0xFF` keeps only the low 8 bits. |
| `ori`       | `ori   rd, rs1, imm`    | `rd = rs1 \| imm`                    | OR immediate. Used to set specific bits without affecting others. |
| `xori`      | `xori  rd, rs1, imm`    | `rd = rs1 ^ imm`                     | XOR immediate. `xori rd, rs, -1` flips all bits (bitwise NOT, see `not` pseudo). |
| `slli`      | `slli  rd, rs1, shamt`  | `rd = rs1 << shamt`                  | Shift Left Logical Immediate. `shamt` is a 5-bit constant (0–31). |
| `srli`      | `srli  rd, rs1, shamt`  | `rd = rs1 >> shamt` (logical)        | Shift Right Logical Immediate. Fills with 0s (unsigned shift). |
| `srai`      | `srai  rd, rs1, shamt`  | `rd = rs1 >> shamt` (arithmetic)     | Shift Right Arithmetic Immediate. Fills with sign bit (signed shift). |
| `slti`      | `slti  rd, rs1, imm`    | `rd = (rs1 < imm) ? 1 : 0`          | Set if less than immediate (signed comparison). |
| `sltiu`     | `sltiu rd, rs1, imm`    | `rd = (rs1 < imm) ? 1 : 0`          | Set if less than immediate (unsigned). Note: `sltiu rd, rs, 1` sets `rd=1` iff `rs==0` (see `seqz` pseudo). |

---

## Load & Store

RISC-V is a **load/store architecture**: arithmetic only operates on registers.
To work with memory values you must explicitly load them into a register first,
then store them back when done.

**Address = base register + signed immediate offset** (the offset is in bytes).

`sign-ext` means the loaded value is sign-extended to 32 bits (the high bits are
filled with the sign bit of the loaded value).  
`zero-ext` means the high bits are filled with zeros (treats the value as unsigned).

| Instruction | Syntax              | Operation                             | Description |
|-------------|---------------------|---------------------------------------|-------------|
| `lw`        | `lw  rd, imm(rs1)`  | `rd = M[rs1+imm]` (32-bit)           | Load Word: reads 4 bytes from memory into `rd`. |
| `lh`        | `lh  rd, imm(rs1)`  | `rd = M[rs1+imm]` (16-bit, sign-ext) | Load Halfword signed: reads 2 bytes, sign-extends to 32 bits. |
| `lhu`       | `lhu rd, imm(rs1)`  | `rd = M[rs1+imm]` (16-bit, zero-ext) | Load Halfword unsigned: reads 2 bytes, zero-extends to 32 bits. |
| `lb`        | `lb  rd, imm(rs1)`  | `rd = M[rs1+imm]` (8-bit, sign-ext)  | Load Byte signed: reads 1 byte, sign-extends. Useful for `char` (signed). |
| `lbu`       | `lbu rd, imm(rs1)`  | `rd = M[rs1+imm]` (8-bit, zero-ext)  | Load Byte unsigned: reads 1 byte, zero-extends. Useful for `unsigned char`. |
| `sw`        | `sw  rs2, imm(rs1)` | `M[rs1+imm] = rs2` (32-bit)          | Store Word: writes all 4 bytes of `rs2` to memory. |
| `sh`        | `sh  rs2, imm(rs1)` | `M[rs1+imm] = rs2[15:0]`             | Store Halfword: writes only the low 16 bits of `rs2`. |
| `sb`        | `sb  rs2, imm(rs1)` | `M[rs1+imm] = rs2[7:0]`              | Store Byte: writes only the low 8 bits of `rs2`. |

> **Example:** `lw t0, 8(sp)` reads the 32-bit word at address `sp + 8` into `t0`.

---

## Conditional Branches (B-type)

Branches compare two registers and **jump to a label if the condition is true**,
otherwise execution continues with the next instruction.
The target address is `pc + offset` (offset is encoded as a signed 13-bit value,
so the range is ±4 KiB from the branch instruction).

| Instruction | Syntax                   | Condition                      | Description |
|-------------|--------------------------|--------------------------------|-------------|
| `beq`       | `beq  rs1, rs2, label`   | `rs1 == rs2`                   | Branch if Equal. |
| `bne`       | `bne  rs1, rs2, label`   | `rs1 != rs2`                   | Branch if Not Equal. |
| `blt`       | `blt  rs1, rs2, label`   | `rs1 < rs2` (signed)           | Branch if Less Than (two's complement comparison). |
| `bge`       | `bge  rs1, rs2, label`   | `rs1 >= rs2` (signed)          | Branch if Greater or Equal (signed). |
| `bltu`      | `bltu rs1, rs2, label`   | `rs1 < rs2` (unsigned)         | Branch if Less Than Unsigned. Use for address/pointer comparisons. |
| `bgeu`      | `bgeu rs1, rs2, label`   | `rs1 >= rs2` (unsigned)        | Branch if Greater or Equal Unsigned. |

> **Note:** There are no `bgt` or `ble` instructions. Use pseudo-instructions instead:
> `bgt rs1, rs2, lbl` expands to `blt rs2, rs1, lbl`, and `ble rs1, rs2, lbl` to `bge rs2, rs1, lbl`.

---

## Unconditional Jumps

| Instruction | Syntax               | Operation                              | Description |
|-------------|----------------------|----------------------------------------|-------------|
| `jal`       | `jal  rd, label`     | `rd = pc+4;  pc = pc + offset`         | Jump And Link: saves the return address (`pc+4`) in `rd`, then jumps. Use `rd = ra` for function calls. Use `rd = x0` to discard the return address (plain jump). Offset range is ±1 MiB. |
| `jalr`      | `jalr rd, imm(rs1)`  | `rd = pc+4;  pc = (rs1+imm) & ~1`      | Jump And Link Register: jumps to an **absolute** address computed from a register + offset (the lowest bit is forced to 0). Used for function returns (`jalr x0, 0(ra)`) and indirect calls through function pointers. |

> **Common uses:**  
> `jal x0, label` → unconditional jump (pseudo: `j label`)  
> `jal ra, label` → call a function  
> `jalr x0, 0(ra)` → return from function (pseudo: `ret`)

---

## Upper Immediate Instructions

These load a 20-bit constant into the **upper** 20 bits of a register.
They are used together with `addi` to build full 32-bit constants or addresses
(since `addi` can only add a 12-bit immediate, you need `lui` to set the top bits first).

| Instruction | Syntax           | Operation                  | Description |
|-------------|------------------|----------------------------|-------------|
| `lui`       | `lui  rd, imm`   | `rd = imm << 12`           | Load Upper Immediate: places `imm` in bits 31–12 of `rd`, clears bits 11–0. Use `lui` + `addi` to load any 32-bit constant. |
| `auipc`     | `auipc rd, imm`  | `rd = pc + (imm << 12)`    | Add Upper Immediate to PC: adds the upper immediate to the current `pc`. Used with `addi` or `jalr` for PC-relative addressing (position-independent code). |

> **Example — load the constant 0x12345678:**
> ```asm
> lui  t0, 0x12345      # t0 = 0x12345000
> addi t0, t0, 0x678    # t0 = 0x12345678
> ```
> ⚠️ If the low 12 bits are ≥ 2048 (bit 11 = 1), sign extension in `addi` subtracts 4096.
> Compensate by adding 1 to the `lui` immediate.

---

## Common Pseudo-instructions

Pseudo-instructions are **assembler shortcuts**: they don't exist in hardware but
are automatically translated to one or two real instructions by the assembler.

| Pseudo             | Expands to                  | Description |
|--------------------|-----------------------------|-------------|
| `nop`              | `addi x0, x0, 0`            | No operation. Wastes one cycle. Sometimes used for timing or alignment. |
| `li rd, imm`       | `lui`+`addi` or just `addi` | Load any 32-bit immediate into `rd`. The assembler picks the shortest encoding. |
| `la rd, label`     | `auipc rd, …` + `addi`      | Load the address of a label into `rd`. Works for PC-relative addresses. |
| `mv rd, rs`        | `addi rd, rs, 0`            | Copy register: `rd = rs`. |
| `neg rd, rs`       | `sub rd, x0, rs`            | Two's complement negation: `rd = -rs`. |
| `not rd, rs`       | `xori rd, rs, -1`           | Bitwise NOT (flip all bits): `rd = ~rs`. |
| `j label`          | `jal x0, label`             | Unconditional jump; return address is discarded. |
| `jr rs`            | `jalr x0, 0(rs)`            | Jump to address in register; return address discarded. |
| `ret`              | `jalr x0, 0(ra)`            | Return from function: jump to the address stored in `ra`. |
| `call label`       | `auipc ra, …` + `jalr ra`   | Call a function anywhere in memory (not limited to ±1 MiB like `jal`). |
| `tail label`       | `auipc t1, …` + `jalr x0`   | Tail call: jump to a far function without saving return address. |
| `beqz rs, lbl`     | `beq rs, x0, lbl`           | Branch if `rs == 0`. |
| `bnez rs, lbl`     | `bne rs, x0, lbl`           | Branch if `rs != 0`. |
| `bgtz rs, lbl`     | `blt x0, rs, lbl`           | Branch if `rs > 0` (signed). |
| `bltz rs, lbl`     | `blt rs, x0, lbl`           | Branch if `rs < 0` (signed). |
| `bgez rs, lbl`     | `bge rs, x0, lbl`           | Branch if `rs >= 0` (signed). |
| `blez rs, lbl`     | `bge x0, rs, lbl`           | Branch if `rs <= 0` (signed). |
| `seqz rd, rs`      | `sltiu rd, rs, 1`           | Set `rd = 1` if `rs == 0`, else 0. |
| `snez rd, rs`      | `sltu rd, x0, rs`           | Set `rd = 1` if `rs != 0`, else 0. |
| `sgtz rd, rs`      | `slt rd, x0, rs`            | Set `rd = 1` if `rs > 0` (signed). |
| `sltz rd, rs`      | `slt rd, rs, x0`            | Set `rd = 1` if `rs < 0` (signed). |

---

## Assembler Directives

Directives are commands **to the assembler**, not to the CPU. They control how
your source code is laid out in memory and how data is defined.

| Directive         | Description |
|-------------------|-------------|
| `.text`           | Switch to the code section. Instructions go here. |
| `.data`           | Switch to the initialized data section. Pre-defined variables go here. |
| `.bss`            | Switch to the uninitialized data section. Variables that start as zero; takes no space in the binary file. |
| `.globl sym`      | Make the label `sym` visible to the linker (required for `main` and exported functions). |
| `.word val`       | Emit a 32-bit integer value (4 bytes). Can also be a label address: `.word my_label`. |
| `.half val`       | Emit a 16-bit integer value (2 bytes). |
| `.byte val`       | Emit a single byte. |
| `.string "s"`     | Emit the string followed by a null terminator `\0`. Use this for strings passed to `print_string` (ecall 4). |
| `.ascii "s"`      | Emit the string **without** a null terminator. |
| `.space n`        | Reserve `n` bytes, all initialized to zero. Used to allocate arrays or buffers. |
| `.align n`        | Pad to a `2^n`-byte boundary. Use `.align 2` before `.word` to ensure 4-byte alignment. |
| `.equ sym, val`   | Define a named constant: `sym` becomes an alias for `val`. Like `#define` in C. |

---

## Calling Convention (RV32I)

The calling convention defines **how functions pass data to each other**.
Following it makes your code interoperate with C libraries and other assembly routines.

```
Caller-saved:   ra, t0–t6, a0–a7
  → The CALLER must save these to the stack before calling another function
    if it needs their values after the call returns.

Callee-saved:   sp, s0–s11
  → The CALLEE (the function being called) must restore these before returning.
    If a function uses s0, it must push it at entry and pop it before ret.

Arguments:      a0, a1, a2, … a7   (first 8 arguments, in order)
Return values:  a0  (and a1 for 64-bit values in RV32)
Stack:          Grows downward. Must be 16-byte aligned when making a call.
```

---

## Ripes Environment Calls (ecall)

> ⚠️ **Ripes-specific** — The codes below are supported by the **Ripes simulator** (v2.x).
> They are **not** standard Linux syscalls and will not work on real hardware or other simulators.  
> To invoke a system call: load the service number into **`a7`**, the argument into **`a0`**
> (if required), then execute `ecall`. For v2.1.0+, the complete list is also in
> **Help → System calls** inside the application.

| `a7` | Name                 | `a0` input                          | Description |
|------|----------------------|-------------------------------------|-------------|
| `0`  | `none`               | -                                   | No operation |
| `1`  | `print_int`          | signed integer                      | Prints `a0` as a signed decimal number (e.g. `-42`). |
| `2`  | `print_float`        | float                               | Prints `a0` as a floating point number. |
| `4`  | `print_str`          | pointer to string                   | Prints the null-terminated string pointed by `a0`. |
| `10` | `exit`               | -                                   | Terminates the program. |
| `11` | `print_char`         | ASCII character                     | Prints the character in `a0`. |
| `17` | `get_cwd`            | buffer address                      | Writes current working directory into buffer (`a1` = buffer size). |
| `30` | `time_ms`            | -                                   | Returns current time in milliseconds. |
| `31` | `cycles`             | -                                   | Returns the number of CPU cycles. |
| `34` | `print_int_hex`      | integer                             | Prints `a0` in hexadecimal format. |
| `35` | `print_int_binary`   | integer                             | Prints `a0` in binary format. |
| `36` | `print_int_unsigned` | unsigned integer                    | Prints `a0` as an unsigned decimal number. |
| `57` | `close`              | file descriptor                     | Closes the file descriptor in `a0`. |
| `62` | `lseek`              | file descriptor                     | Moves file position (`a1` = offset, `a2` = whence: 0=start, 1=current, 2=end). |
| `63` | `read`               | file descriptor                     | Reads bytes into memory (`a1` = buffer, `a2` = length). |
| `64` | `write`              | file descriptor                     | Writes bytes from memory (`a1` = buffer, `a2` = length). |
| `80` | `fstat`              | file descriptor                     | Gets file info (`a1` = struct pointer). Currently stub (returns 0). |
| `93` | `exit2`              | exit code                           | Terminates program with return code. |
| `214`| `brk`                | address                             | Adjusts program break (heap end). |
| `1024`| `open`              | pointer to path string              | Opens file (`a1` = flags) and returns file descriptor. |

---

## M Extension — Multiply & Divide

> Enable with `--isaexts M` in the Ripes CLI, or check the **M** box in the
> processor configuration dialog.

All results are 32-bit. For multiplication, the **full 64-bit product** is
split across two instructions: `mul` gives the low half, `mulh*` gives the high half.

| Instruction           | Operation                              | Description |
|-----------------------|----------------------------------------|-------------|
| `mul  rd, rs1, rs2`   | `rd = (rs1 × rs2)[31:0]`              | Low 32 bits of the product. Works for both signed and unsigned if you only need the lower half. |
| `mulh rd, rs1, rs2`   | `rd = (rs1 × rs2)[63:32]` (s × s)     | High 32 bits of signed × signed product. Use to detect overflow. |
| `mulhu rd, rs1, rs2`  | `rd = (rs1 × rs2)[63:32]` (u × u)     | High 32 bits of unsigned × unsigned product. |
| `mulhsu rd, rs1, rs2` | `rd = (rs1 × rs2)[63:32]` (s × u)     | High 32 bits: `rs1` signed, `rs2` unsigned. |
| `div  rd, rs1, rs2`   | `rd = rs1 / rs2` (signed)             | Signed integer division, truncated toward zero. Division by zero gives -1. |
| `divu rd, rs1, rs2`   | `rd = rs1 / rs2` (unsigned)           | Unsigned integer division. Division by zero gives 2³²−1. |
| `rem  rd, rs1, rs2`   | `rd = rs1 % rs2` (signed)             | Signed remainder. Sign of result matches `rs1`. |
| `remu rd, rs1, rs2`   | `rd = rs1 % rs2` (unsigned)           | Unsigned remainder. |

---

## Main ISA Extensions (letter suffixes)

The processor name is built from letters, e.g. `RV32IMC` = 32-bit base + Multiply + Compressed.

| Letter  | Extension  | Description |
|---------|------------|-------------|
| `I`     | Integer    | Base integer ISA. Mandatory for all RV32 implementations. |
| `M`     | Multiply   | Hardware multiply and divide (`mul`, `div`, `rem`, …). Without it, these must be emulated in software. |
| `A`     | Atomic     | Atomic read-modify-write operations (`lr.w`, `sc.w`, `amoadd.w`, …). Needed for multi-threaded / OS code. |
| `F`     | Float      | Single-precision (32-bit) IEEE 754 floating point. Adds 32 FP registers (`f0`–`f31`). |
| `D`     | Double     | Double-precision (64-bit) IEEE 754 floating point. Requires F. |
| `C`     | Compressed | 16-bit versions of the most common instructions (RVC). Reduces code size by ~25%. |
| `Zicsr` | CSR        | Instructions to read/write control and status registers (`csrr`, `csrw`, …). Needed for timers, counters, privilege modes. |

---

*Reference: RISC-V ISA Specification v2.2 — Volume I: Unprivileged ISA*  
*Ecall table: Ripes v2.x — [ripes.me/Ripes/docs/ecalls.html](https://ripes.me/Ripes/docs/ecalls.html)*