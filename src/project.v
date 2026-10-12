/*
 * Copyright (c) 2026 Mark Arnold
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "newtinyalu8.v"

module tt_um_markgarnold_lnsalu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


// All output pins must be assigned. If not used, assign to 0.
    assign uo_out  = (ui_in + uio_in)^8'h00;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};


    wire ai,bi,ld;
    wire [1:0] sel;
    wire [6:0] alufunc;
    wire [7:0] outp;
    
    assign alufunc = uio_in[6:0];
    assign ai = ui_in[0];
    assign bi = ui_in[1];
    assign ld = ui_in[2];
    assign sel = ui_in[4:3];
  
    tiny_test tinytestinstance(ai,bi,ld,sel,alu_func,uo_out,clk);
*/
    //module tiny_test(ai,bi,ld,sel,alu_func,outp,clk);
    
    // All output pins must be assigned. If not used, assign to 0.
    assign uo_out  = outp;  
    assign uio_out = 0;
    assign uio_oe  = 0;
    
    
  // List all unused inputs to prevent warnings
    wire _unused = &{ena,rst_n,uio_in[7],ui_in[7:5], 1'b0};
*/
endmodule
