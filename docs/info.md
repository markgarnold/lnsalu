

## How it works

A wrapper surrounds an 32-bit integer ALU (just an adder/subtractor at the moment) to add functionality for LMUL, LDIV and LIM.

## How to test

Pulse ld to read ai and bi into internal 32-bit A and B registers, which are input to the ALU. (this takes at least 32 clock cycles).  Once values are loaded, leave ld inactive, choose and alufunc to test, and use sel to select one byte of the ALU's ouptut on outp.

## External hardware

None
