`define SIZE 24
`define ZEROS 23'b00000000000000000000000
`define ONES  23'b11111111111111111111111

module oldalu(r,a,b,op);
   input op;
   input [31:0] a,b;
   output [31:0] r;
   assign r = (op==0) ? a+b : a-b;
endmodule


module ideal_sb(out_sbz, in_z, sb_mode);
  output [`SIZE-1:0] out_sbz;
  input  [`SIZE-1:0] in_z;
  input sb_mode;
 
  reg [`SIZE-1:0] out_sbz; 
  //reg [`SIZE-1:0] dirsb[0:65535];

  `include "lpvip24.v"

  always @(in_z or sb_mode)
     out_sbz = sb_mode ? /*lpvip(in_z)*/ 0 : in_z;
endmodule
   
module newaluwrap(r,a,b,rorig,op,lnsmode);
   input  [`SIZE-1:0] a,b;
   output [`SIZE-1:0] r;
   input  [`SIZE-1:0] rorig;
   input op,lnsmode;
   wire correctsign = a[`SIZE-1] ^ b[`SIZE-1];
   wire[1:0] rnewhigh = rorig[`SIZE-1:`SIZE-2] + ((op==0) ? 2'b11 :  2'b01);
   wire overunder = correctsign ^ rnewhigh[1];
   assign r = (lnsmode==0) ? rorig : (overunder==0) ?  {rnewhigh,rorig[`SIZE-3:0]} : 
                                                       rnewhigh[0] ? {correctsign,`ZEROS}: 
                                                                     {correctsign,`ONES};
endmodule

module newalu(r,a,borig,op,lnsmode,sbmode);
   input  [31:0] a,borig;
   output [31:0] r;
   input  op,lnsmode,sbmode;
   wire   [31:0] rorig;
   wire   [`SIZE-1:0] b,rlow;

   ideal_sb   sbtable(b,borig[23:0],sbmode); 
   oldalu     origalu(rorig,a,{borig[31:24],b},op);
   newaluwrap enhancedalu(rlow,a[23:0],b[23:0],rorig[23:0],op,lnsmode);
   assign     r = {rorig[31:24],rlow};
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
     newalu alu_instance(alu_out, a, b,
                       alu_func[0],alu_func[5],alu_func[6]);//op,lnsmode,sbmode
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

