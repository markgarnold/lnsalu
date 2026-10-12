`define SIZE 16
`define ZEROS 15'b000000000000000
`define ONES  15'b111111111111111

module oldalu(r,a,b,op);
   input op;
   input [2*`SIZE-1:0] a,b;
   output [2*`SIZE-1:0] r;
   assign r = (op==0) ? a+b : a-b;
endmodule


module ideal_sb(out_sbz, in_z, sb_mode);
  output [`SIZE-1:0] out_sbz;
  input  [`SIZE-1:0] in_z;
  input sb_mode;
 
  reg [`SIZE-1:0] out_sbz; 
  //reg [`SIZE-1:0] dirsb[0:65535];

  `include "lpvip.v"

  //initial
     //$readmemh("dirsb_ideal.hex",dirsb);
     //$readmemh("dirsb_lpvip.hex",dirsb);
  always @(in_z or sb_mode)
     out_sbz = sb_mode ? lpvip(in_z) : in_z;
     //out_sbz = sb_mode ? dirsb[in_z] : in_z;
endmodule
   
module newaluwrap(r,a,b,rorig,op,lnsmode);
   input  [`SIZE-1:0] a,b;
   output [`SIZE-1:0] r;
   input  [`SIZE-1:0] rorig;
   input op,lnsmode;
   assign correctsign = a[`SIZE-1] ^ b[`SIZE-1];
   wire[1:0] rnewhigh = rorig[`SIZE-1:`SIZE-2] + ((op==0) ? 2'b11 :  2'b01);
   wire overunder = correctsign ^ rnewhigh[1];
   assign r = (lnsmode==0) ? rorig : (overunder==0) ?  {rnewhigh,rorig[`SIZE-3:0]} : 
                                                       rnewhigh[0] ? {correctsign,`ZEROS}: 
                                                                     {correctsign,`ONES};
endmodule

module newalu(r,a,borig,op,lnsmode,sbmode);
   input  [2*`SIZE-1:0] a,borig;
   output [2*`SIZE-1:0] r;
   input  op,lnsmode,sbmode;
   wire   [2*`SIZE-1:0] rorig;
   wire   [`SIZE-1:0] b,rlow;

   ideal_sb   sbtable(b,borig[15:0],sbmode); 
   oldalu     origalu(rorig,a,{borig[31:16],b},op);
   newaluwrap enhancedalu(rlow,a[15:0],b[15:0],rorig[15:0],op,lnsmode);
   assign     r = {rorig[31:16],rlow};
endmodule
/////////////////////////////
//`define N 4

module tiny_test(ai,bi,ld,sel,alu_func,outp,clk);
   input ai;
   input bi;
   input ld;
   input [1:0] sel;
   input [6:0] alu_func;
   input clk;
  `ifdef N 
     wire [32-4*`N-1:0] dummy_out,zeros;
     assign zeros = 0;
     output [`N-1:0] outp;
     reg [4*`N-1:0] a,b;
     wire [4*`N-1:0] alu_out;
     reg [`N-1:0] outp;
     newalu alu_instance({dummy_out,alu_out},
                       {zeros,a},
                       {zeros,b},
                       alu_func[0],alu_func[5],alu_func[6]);//op,lnsmode,sbmode
  `else
    `define N 8
     output [`N-1:0] outp;
     reg [4*`N-1:0] a,b;
     wire [4*`N-1:0] alu_out;
     reg [`N-1:0] outp;
     //newalu alu_instance(alu_out, a, b,
     //                  alu_func[0],alu_func[5],alu_func[6]);//op,lnsmode,sbmode
   //oldalu alu_instance(alu_out, a, b,alu_func[0]);
   assign alu_out=a+b;
  `endif



   always @(posedge clk)
     begin
       if (ld)
         begin
           a <= {a[4*`N-2:0],ai};
           b <= {b[4*`N-2:0],bi};
         end
     end
   //alu_test alu_instance(a,b,alu_func,alu_out);
   //newalu(r,a,borig,op,lnsmode,sbmode);
   always @(sel or alu_out)
     begin
       case(sel)
         0: outp = alu_out[  `N-1:   0];
         1: outp = alu_out[2*`N-1:  `N];
         2: outp = alu_out[3*`N-1:2*`N];
         3: outp = alu_out[4*`N-1:3*`N];
       endcase
     end
endmodule

