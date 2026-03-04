## How it works

This project implements a basic 4-bit ALU (Arithmetic Logic Unit) that supports 8 operations selected by a 3-bit opcode. Operand A is provided on `ui[7:4]`, Operand B on `ui[3:0]`, and the opcode on `uio[2:0]`. The 8-bit result is output on `uo[7:0]`.

| Opcode (uio[2:0]) | Operation   | Description              |
|--------------------|-------------|--------------------------|
| 000                | ADD         | A + B                    |
| 001                | SUB         | A - B                    |
| 010                | AND         | A & B                    |
| 011                | OR          | A \| B                   |
| 100                | XOR         | A ^ B                    |
| 101                | NOT         | ~A                       |
| 110                | Shift Left  | A << 1                   |
| 111                | Shift Right | A >> 1                   |

The design is fully combinational — no clock is required.

## How to test

1. Set `ui[7:4]` to your desired value for Operand A (4 bits)
2. Set `ui[3:0]` to your desired value for Operand B (4 bits)
3. Set `uio[2:0]` to the opcode for the operation you want
4. Read the result from `uo[7:0]`

**Example — ADD 3 + 2:**
- `ui = 8'b0011_0010` (A=3, B=2)
- `uio[2:0] = 3'b000` (ADD)
- Expected output: `uo = 8'b00000101` (5)

**Example — AND 3 & 2:**
- `ui = 8'b0011_0010` (A=3, B=2)
- `uio[2:0] = 3'b010` (AND)
- Expected output: `uo = 8'b00000010` (2)

## External hardware

None required. 
