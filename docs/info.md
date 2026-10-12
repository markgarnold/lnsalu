

## How it works

A wrapper surrounds an 32-bit integer ALU (just an adder/subtractor at the moment) to add functionality for LMUL, LDIV and LIM.

## How to test

Pulse `ld` to shift `ai` and `bi` lsb first into internal 32-bit `A` and `B` registers, which are input to the ALU. (This takes at least 32 clock cycles).  Once values are loaded, leave `ld` inactive, choose and `alufunc` to test, and use sel to select one byte of the ALU's ouptut on `outp`. The low-order 5 bits of `alufunc` are for reserved for RISC-V opcode; the other two bits trigger Gaussian mode for the Logarithmic Increment and Multiply (LIM) instruction, and LNS mode for the LIM, LDIV and LADD. 

## External hardware

None
