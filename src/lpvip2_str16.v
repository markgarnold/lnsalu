`include "lpvip2_gate_plain.v"
//`include "lpvip2_gate_tally.v"
/*
module shift1(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  
  assign bus_out = (sel)? bus_in>>1 : bus_in;
endmodule

module shift2(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  
  assign bus_out = (sel)? bus_in>>2 : bus_in;
endmodule

module shift4(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  
  assign bus_out = (sel)? bus_in>>4 : bus_in;
endmodule
*/

module shift1(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  mux2 mux0(bus_out[0], bus_in[0], bus_in[1], sel);
  mux2 mux1(bus_out[1], bus_in[1], bus_in[2], sel);
  mux2 mux2(bus_out[2], bus_in[2], bus_in[3], sel);
  mux2 mux3(bus_out[3], bus_in[3], bus_in[4], sel);
  mux2 mux4(bus_out[4], bus_in[4], bus_in[5], sel);  
  mux2 mux5(bus_out[5], bus_in[5], bus_in[6], sel);  
  mux2 mux6(bus_out[6], bus_in[6], bus_in[7], sel);  
  mux2 mux7(bus_out[7], bus_in[7], 1'b0,      sel);  
endmodule


module shift2(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  mux2 mux0(bus_out[0], bus_in[0], bus_in[2], sel);
  mux2 mux1(bus_out[1], bus_in[1], bus_in[3], sel);
  mux2 mux2(bus_out[2], bus_in[2], bus_in[4], sel);
  mux2 mux3(bus_out[3], bus_in[3], bus_in[5], sel);
  mux2 mux4(bus_out[4], bus_in[4], bus_in[6], sel);
  mux2 mux5(bus_out[5], bus_in[5], bus_in[7], sel);
  mux2 mux6(bus_out[6], bus_in[6], 1'b0,      sel);
  mux2 mux7(bus_out[7], bus_in[7], 1'b0,      sel);  
endmodule

module shift4(bus_out, bus_in, sel);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input sel;
  mux2 mux0(bus_out[0], bus_in[0], bus_in[4], sel);
  mux2 mux1(bus_out[1], bus_in[1], bus_in[5], sel);
  mux2 mux2(bus_out[2], bus_in[2], bus_in[6], sel);
  mux2 mux3(bus_out[3], bus_in[3], bus_in[7], sel);
  mux2 mux4(bus_out[4], bus_in[4], 1'b0,      sel);
  mux2 mux5(bus_out[5], bus_in[5], 1'b0,      sel);
  mux2 mux6(bus_out[6], bus_in[6], 1'b0,      sel);
  mux2 mux7(bus_out[7], bus_in[7], 1'b0,      sel);
endmodule

module shift7(bus_out, bus_in, distan);
  input [`F:0] bus_in;
  output [`F:0] bus_out;
  input [2:0] distan;
  wire [`F:0] temp;
  wire [`F:0] temp2;
  shift1 s1(temp, bus_in, distan[0]);
  shift2 s2(temp2, temp, distan[1]);
  shift4 s4(bus_out, temp2, distan[2]);
endmodule


module mitchell(two_to_z, z);
  input [`W-1:0] z;
  output [`F:0] two_to_z;
  wire [`F:0] temp;
  wire zb,zc,zd;
  shift7 s7(temp, {1'b1,z[`F-1:0]} , ~z[`F+2:`F]);


  //always @(z) #100 $display("in mit,z=%h",z);
  //wire two_to_z_gate = (z[14:10]==5'b11111); //|(z==0);
  wire two_to_z_gate;
  mit_and gate0(zb,            z[11], z[10]);
  mit_and gate1(zc,            z[12], zb);
  mit_and gate2(zd,            z[13], zc);
  mit_and gate3(two_to_z_gate, z[14], zd);

  mit_and and0(two_to_z[0], temp[1], two_to_z_gate);
  mit_and and1(two_to_z[1], temp[2], two_to_z_gate);
  mit_and and2(two_to_z[2], temp[3], two_to_z_gate);
  mit_and and3(two_to_z[3], temp[4], two_to_z_gate);
  mit_and and4(two_to_z[4], temp[5], two_to_z_gate);
  mit_and and5(two_to_z[5], temp[6], two_to_z_gate);
  mit_and and6(two_to_z[6], temp[7], two_to_z_gate);

  assign two_to_z[`F] = (z==15'h0000);  
endmodule  

/*
module db_small_z_rom(sbdb_z, small_z);
  input [`F-1:0] small_z;
  output [`W-1:0] sbdb_z;

  `include "lpvipsingcase.v"
  //always @(small_z) #1 $display("small_z=%h %h",small_z,lpvipsing({9'b101111111 , small_z}));

  assign sbdb_z = -(15'h4000^lpvipsing({9'b101111111 , small_z}));
endmodule
*/ 

module db_small_z_rom(sbdb_z, small_z);
input [`F-1:0] small_z;
output [`W-1:0] sbdb_z;
reg [`W-1:0] sbdb_z;
always @(small_z)
begin
  //sbdb_z=0;
  
 case(small_z)
  7'h00:sbdb_z=15'h0078;
  7'h01:sbdb_z=15'h0080;
  7'h02:sbdb_z=15'h0081;
  7'h03:sbdb_z=15'h0082;
  7'h04:sbdb_z=15'h0083;
  7'h05:sbdb_z=15'h0084;
  7'h06:sbdb_z=15'h0085;
  7'h07:sbdb_z=15'h0086;
  7'h08:sbdb_z=15'h0087;
  7'h09:sbdb_z=15'h0088;
  7'h0a:sbdb_z=15'h008a;
  7'h0b:sbdb_z=15'h008b;
  7'h0c:sbdb_z=15'h008c;
  7'h0d:sbdb_z=15'h008d;
  7'h0e:sbdb_z=15'h008e;
  7'h0f:sbdb_z=15'h008f;
  7'h10:sbdb_z=15'h0091;
  7'h11:sbdb_z=15'h0092;
  7'h12:sbdb_z=15'h0093;
  7'h13:sbdb_z=15'h0094;
  7'h14:sbdb_z=15'h0095;
  7'h15:sbdb_z=15'h0097;
  7'h16:sbdb_z=15'h0098;
  7'h17:sbdb_z=15'h0099;
  7'h18:sbdb_z=15'h009b;
  7'h19:sbdb_z=15'h009c;
  7'h1a:sbdb_z=15'h009d;
  7'h1b:sbdb_z=15'h009f;
  7'h1c:sbdb_z=15'h00a0;
  7'h1d:sbdb_z=15'h00a1;
  7'h1e:sbdb_z=15'h00a3;
  7'h1f:sbdb_z=15'h00a4;
  7'h20:sbdb_z=15'h00a6;
  7'h21:sbdb_z=15'h00a7;
  7'h22:sbdb_z=15'h00a9;
  7'h23:sbdb_z=15'h00aa;
  7'h24:sbdb_z=15'h00ac;
  7'h25:sbdb_z=15'h00ad;
  7'h26:sbdb_z=15'h00af;
  7'h27:sbdb_z=15'h00b1;
  7'h28:sbdb_z=15'h00b2;
  7'h29:sbdb_z=15'h00b4;
  7'h2a:sbdb_z=15'h00b5;
  7'h2b:sbdb_z=15'h00b7;
  7'h2c:sbdb_z=15'h00b9;
  7'h2d:sbdb_z=15'h00bb;
  7'h2e:sbdb_z=15'h00bc;
  7'h2f:sbdb_z=15'h00be;
  7'h30:sbdb_z=15'h00c0;
  7'h31:sbdb_z=15'h00c2;
  7'h32:sbdb_z=15'h00c4;
  7'h33:sbdb_z=15'h00c6;
  7'h34:sbdb_z=15'h00c8;
  7'h35:sbdb_z=15'h00ca;
  7'h36:sbdb_z=15'h00cc;
  7'h37:sbdb_z=15'h00ce;
  7'h38:sbdb_z=15'h00d0;
  7'h39:sbdb_z=15'h00d2;
  7'h3a:sbdb_z=15'h00d4;
  7'h3b:sbdb_z=15'h00d6;
  7'h3c:sbdb_z=15'h00d8;
  7'h3d:sbdb_z=15'h00db;
  7'h3e:sbdb_z=15'h00dd;
  7'h3f:sbdb_z=15'h00df;
  7'h40:sbdb_z=15'h00e2;
  7'h41:sbdb_z=15'h00e4;
  7'h42:sbdb_z=15'h00e7;
  7'h43:sbdb_z=15'h00e9;
  7'h44:sbdb_z=15'h00ec;
  7'h45:sbdb_z=15'h00ee;
  7'h46:sbdb_z=15'h00f1;
  7'h47:sbdb_z=15'h00f4;
  7'h48:sbdb_z=15'h00f7;
  7'h49:sbdb_z=15'h00f9;
  7'h4a:sbdb_z=15'h00fc;
  7'h4b:sbdb_z=15'h00ff;
  7'h4c:sbdb_z=15'h0102;
  7'h4d:sbdb_z=15'h0106;
  7'h4e:sbdb_z=15'h0109;
  7'h4f:sbdb_z=15'h010c;
  7'h50:sbdb_z=15'h010f;
  7'h51:sbdb_z=15'h0113;
  7'h52:sbdb_z=15'h0116;
  7'h53:sbdb_z=15'h011a;
  7'h54:sbdb_z=15'h011d;
  7'h55:sbdb_z=15'h0121;
  7'h56:sbdb_z=15'h0125;
  7'h57:sbdb_z=15'h0129;
  7'h58:sbdb_z=15'h012d;
  7'h59:sbdb_z=15'h0131;
  7'h5a:sbdb_z=15'h0136;
  7'h5b:sbdb_z=15'h013a;
  7'h5c:sbdb_z=15'h013f;
  7'h5d:sbdb_z=15'h0143;
  7'h5e:sbdb_z=15'h0148;
  7'h5f:sbdb_z=15'h014d;
  7'h60:sbdb_z=15'h0152;
  7'h61:sbdb_z=15'h0158;
  7'h62:sbdb_z=15'h015d;
  7'h63:sbdb_z=15'h0163;
  7'h64:sbdb_z=15'h0169;
  7'h65:sbdb_z=15'h016f;
  7'h66:sbdb_z=15'h0176;
  7'h67:sbdb_z=15'h017d;
  7'h68:sbdb_z=15'h0184;
  7'h69:sbdb_z=15'h018b;
  7'h6a:sbdb_z=15'h0193;
  7'h6b:sbdb_z=15'h019b;
  7'h6c:sbdb_z=15'h01a3;
  7'h6d:sbdb_z=15'h01ac;
  7'h6e:sbdb_z=15'h01b6;
  7'h6f:sbdb_z=15'h01c0;
  7'h70:sbdb_z=15'h01cb;
  7'h71:sbdb_z=15'h01d6;
  7'h72:sbdb_z=15'h01e2;
  7'h73:sbdb_z=15'h01ef;
  7'h74:sbdb_z=15'h01fe;
  7'h75:sbdb_z=15'h020d;
  7'h76:sbdb_z=15'h021e;
  7'h77:sbdb_z=15'h0231;
  7'h78:sbdb_z=15'h0247;
  7'h79:sbdb_z=15'h025f;
  7'h7a:sbdb_z=15'h027b;
  7'h7b:sbdb_z=15'h029c;
  7'h7c:sbdb_z=15'h02c5;
  7'h7d:sbdb_z=15'h02f9;
  7'h7e:sbdb_z=15'h0344;
  7'h7f:sbdb_z=15'h03c3;
 endcase
 
end
endmodule


module inc_half_adder(c,s,a,b);
  output c,s;
  input a,b;
  inc_xor x1(s,a,b);
  inc_and a1(c,a,b);
endmodule

module half_adder(c,s,a,b);
  output c,s;
  input a,b;
  my_xor x1(s,a,b);
  my_and a1(c,a,b);
endmodule

module full_adder(cout,s,a,b,cin);
  output cout,s;
  input a,b,cin;
  wire cout1,cout2,temp;
  half_adder ha2(cout1, temp, a,b);
  half_adder ha3(cout2, s, cin, temp);
  my_or o1(cout, cout1, cout2);
endmodule


module add15(p, a, b, c);
  input [`W-1:0] a,b;
  input c;
  output [`W-1:0] p;
  wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,ca,cb,cc,cd,ce,cf;
  full_adder fa0(c0, p[0], a[0], b[0], c);
  full_adder fa1(c1, p[1], a[1], b[1], c0);
  full_adder fa2(c2, p[2], a[2], b[2], c1);
  full_adder fa3(c3, p[3], a[3], b[3], c2);
  full_adder fa4(c4, p[4], a[4], b[4], c3);
  full_adder fa5(c5, p[5], a[5], b[5], c4);
  full_adder fa6(c6, p[6], a[6], b[6], c5);
  full_adder fa7(c7, p[7], a[7], b[7], c6);
  full_adder fa8(c8, p[8], a[8], b[8], c7);
  full_adder fa9(c9, p[9], a[9], b[9], c8);
  full_adder faa(ca, p[10], a[10], b[10], c9);
  full_adder fab(cb, p[11], a[11], b[11], ca);
  full_adder fac(cc, p[12], a[12], b[12], cb);
  full_adder fad(cd, p[13], a[13], b[13], cc);
  full_adder fae(ce, p[14], a[14], b[14], cd);
  //assign p = a + b + c;
endmodule  

module incrementor7(out, z, c0);
  input [6:0] z;
  input c0;
  output [6:0] out;
  wire c0,c1,c2,c3,c4,c5,c6,c7;

  inc_half_adder inc0(c1, out[0], z[0], c0);
  inc_half_adder inc1(c2, out[1], z[1], c1);
  inc_half_adder inc2(c3, out[2], z[2], c2);
  inc_half_adder inc3(c4, out[3], z[3], c3);
  inc_half_adder inc4(c5, out[4], z[4], c4);
  inc_half_adder inc5(c6, out[5], z[5], c5);
  inc_half_adder inc6(c7, out[6], z[6], c6);
endmodule

module incrementor11(out, z, c0);
  input [10:0] z;
  input c0;
  output [10:0] out;
  wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,ca,cb;

  inc_half_adder inc0(c1, out[0], z[0], c0);
  inc_half_adder inc1(c2, out[1], z[1], c1);
  inc_half_adder inc2(c3, out[2], z[2], c2);
  inc_half_adder inc3(c4, out[3], z[3], c3);
  inc_half_adder inc4(c5, out[4], z[4], c4);
  inc_half_adder inc5(c6, out[5], z[5], c5);
  inc_half_adder inc6(c7, out[6], z[6], c6);
  inc_half_adder inc7(c8, out[7], z[7], c7);
  inc_half_adder inc8(c9, out[8], z[8], c8);
  inc_half_adder inc9(ca, out[9], z[9], c9);
  inc_half_adder inca(cb, out[10], z[10], ca);
endmodule


module incrementor15(out, z, c0);
  input [14:0] z;
  input c0;
  output [14:0] out;
  wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,ca,cb,cc,cd,ce,cf;

  inc_half_adder inc0(c1, out[0], z[0], c0);
  inc_half_adder inc1(c2, out[1], z[1], c1);
  inc_half_adder inc2(c3, out[2], z[2], c2);
  inc_half_adder inc3(c4, out[3], z[3], c3);
  inc_half_adder inc4(c5, out[4], z[4], c4);
  inc_half_adder inc5(c6, out[5], z[5], c5);
  inc_half_adder inc6(c7, out[6], z[6], c6);
  inc_half_adder inc7(c8, out[7], z[7], c7);
  inc_half_adder inc8(c9, out[8], z[8], c8);
  inc_half_adder inc9(ca, out[9], z[9], c9);
  inc_half_adder inca(cb, out[10], z[10], ca);
  inc_half_adder incb(cc, out[11], z[11], cb);
  inc_half_adder incc(cd, out[12], z[12], cc);
  inc_half_adder incd(ce, out[13], z[13], cd);
  inc_half_adder ince(cf, out[14], z[14], ce);
endmodule

module negate15(out, z, c0);
  input [14:0] z;
  input c0;
  output [14:0] out;
  wire [14:0] nz;

  my_xor x0(nz[0],z[0],c0);
  my_xor x1(nz[1],z[1],c0);
  my_xor x2(nz[2],z[2],c0);
  my_xor x3(nz[3],z[3],c0);
  my_xor x4(nz[4],z[4],c0);
  my_xor x5(nz[5],z[5],c0);
  my_xor x6(nz[6],z[6],c0);
  my_xor x7(nz[7],z[7],c0);
  my_xor x8(nz[8],z[8],c0);
  my_xor x9(nz[9],z[9],c0);
  my_xor xa(nz[10],z[10],c0);
  my_xor xb(nz[11],z[11],c0);
  my_xor xc(nz[12],z[12],c0);
  my_xor xd(nz[13],z[13],c0);
  my_xor xe(nz[14],z[14],c0);

  incrementor15 inc(out, nz, c0);
  //always @(z or out) #100 $display("z=%h -z=%h",z,out);
endmodule

module incrementor(out, z, sub_mode);
  input [`W-1:0] z;
  input sub_mode;
  output [`W-1:0] out;
  wire c0,c1,c2,c3,c4,c5,c6,c7;
  wire [`W-1-`F:0] zint = z[`W-1:`F]; 
  wire [`W-1-`F:0] zintinc;

  //assign zintinc = zint + sub_mode;
  inc_half_adder inc0(c0, zintinc[0], zint[0], sub_mode);
  inc_half_adder inc1(c1, zintinc[1], zint[1], c0);
  inc_half_adder inc2(c2, zintinc[2], zint[2], c1);
  inc_half_adder inc3(c3, zintinc[3], zint[3], c2);
  inc_half_adder inc4(c4, zintinc[4], zint[4], c3);
  inc_half_adder inc5(c5, zintinc[5], zint[5], c4);
  inc_half_adder inc6(c6, zintinc[6], zint[6], c5);
  assign out = {zint[`W-1-`F],zintinc[`W-2-`F:0], z[`F-1:0]};
endmodule


module sbdb_mux(sbdb_z, sbdb_temp, sbdb_small_z, sub_mode, z);
  output [`W-1:0] sbdb_z;
  input [`W-1:0] sbdb_temp, sbdb_small_z;
  input sub_mode;
  input [`W-1:0] z;

  //always @(z) if (sub_mode & ((z>>`F)==255)) $display("*%b",z);
  //wire two_to_z_gate = ((z>>`F)==255); 
  //assign sbdb_z = (sub_mode & two_to_z_gate) ? sbdb_small_z : sbdb_temp;
  //assign sbdb_z = (sel) ? sbdb_small_z : sbdb_temp;

  wire t1,t2,t3,t4,t5,t6,t7;
  wire sel;
  sbdb_and seland1(t1,z[7],z[8]);
  sbdb_and seland2(t2,z[9],z[10]);
  sbdb_and seland3(t3,z[11],z[12]);
  sbdb_and seland4(t4,z[13],z[14]);
  sbdb_and seland5(t5,t1,t2);
  sbdb_and seland6(t6,t3,t4);
  sbdb_and seland7(t7,t5,t6);
  sbdb_and seland8(sel,t7,sub_mode);
  //always @(sel) #100 $display("sel=",sel);
  //wire sel = (sub_mode & (&z[`W-1:`F]));
  mux2_sbdb m0(sbdb_z[0], sbdb_temp[0], sbdb_small_z[0], sel); 
  mux2_sbdb m1(sbdb_z[1], sbdb_temp[1], sbdb_small_z[1], sel); 
  mux2_sbdb m2(sbdb_z[2], sbdb_temp[2], sbdb_small_z[2], sel); 
  mux2_sbdb m3(sbdb_z[3], sbdb_temp[3], sbdb_small_z[3], sel); 
  mux2_sbdb m4(sbdb_z[4], sbdb_temp[4], sbdb_small_z[4], sel); 
  mux2_sbdb m5(sbdb_z[5], sbdb_temp[5], sbdb_small_z[5], sel); 
  mux2_sbdb m6(sbdb_z[6], sbdb_temp[6], sbdb_small_z[6], sel); 
  mux2_sbdb m7(sbdb_z[7], sbdb_temp[7], sbdb_small_z[7], sel); 
  mux2_sbdb m8(sbdb_z[8], sbdb_temp[8], sbdb_small_z[8], sel); 
  mux2_sbdb m9(sbdb_z[9], sbdb_temp[9], sbdb_small_z[9], sel); 
  mux2_sbdb ma(sbdb_z[10],sbdb_temp[10],sbdb_small_z[10],sel); 
  mux2_sbdb mb(sbdb_z[11],sbdb_temp[11],sbdb_small_z[11],sel); 
  mux2_sbdb mc(sbdb_z[12],sbdb_temp[12],sbdb_small_z[12],sel); 
  mux2_sbdb md(sbdb_z[13],sbdb_temp[13],sbdb_small_z[13],sel); 
  mux2_sbdb me(sbdb_z[14],sbdb_temp[14],sbdb_small_z[14],sel); 
  //assign sbdb_z[15] = 1'b0;
endmodule

module half_subber(c,s,a,b);
  output c,s;
  input a,b;
  //assign s = ((~a)^b);
  //assign c = (a&b);
  sub_xor x1(s,~a,b);
  sub_and a1(c,a,b);
endmodule

/*

module decrementor(low_db_dec, low_db, z, sub_mode);
  input [`W-1:0] low_db;
  input [`W-1:0] z;
  input sub_mode;
  output [`W-1:0] low_db_dec;
  wire c0,c1,c2,c3,c4,c5,c6,c7,c8;
  wire c9,ca,cb,cc,cd,ce,cf;


  assign c0 = sub_mode;
  
  half_subber hs0(c1, low_db_dec[0], ~low_db[0], c0);
  half_subber hs1(c2, low_db_dec[1], ~low_db[1], c1);
  half_subber hs2(c3, low_db_dec[2], ~low_db[2], c2); 
  half_subber hs3(c4, low_db_dec[3], ~low_db[3], c3);
  half_subber hs4(c5, low_db_dec[4], ~low_db[4], c4);
  half_subber hs5(c6, low_db_dec[5], ~low_db[5], c5);
  half_subber hs6(c7, low_db_dec[6], ~low_db[6], c6);
  half_subber hs7(c8, low_db_dec[7], ~low_db[7], c7);
  half_subber hs8(c9, low_db_dec[8], ~low_db[8], c8);
  half_subber hs9(ca, low_db_dec[9], ~low_db[9], c9);
  half_subber hsa(cb, low_db_dec[10],~low_db[10],ca);
  half_subber hsb(cc, low_db_dec[11],~low_db[11],cb);
  half_subber hsc(cd, low_db_dec[12],~low_db[12],cc);
  half_subber hsd(ce, low_db_dec[13],~low_db[13],cd);
  half_subber hse(cf, low_db_dec[14],~low_db[14],ce);
endmodule

module decrementor7(low_dec, low, sub_mode);
  input [`F-1:0] low;
  output [`F-1:0] low_dec;
  input sub_mode;
  wire c0,c1,c2,c3,c4,c5,c6,c7;


  assign c0 = sub_mode;
  
  half_subber hs0(c1, low_dec[0], low[0], c0);
  half_subber hs1(c2, low_dec[1], low[1], c1);
  half_subber hs2(c3, low_dec[2], low[2], c2); 
  half_subber hs3(c4, low_dec[3], low[3], c3);
  half_subber hs4(c5, low_dec[4], low[4], c4);
  half_subber hs5(c6, low_dec[5], low[5], c5);
  half_subber hs6(c7, low_dec[6], low[6], c6);
endmodule
*/

module precond_mux(bus_out, a, b, sel);
  input [`W-1:0] a,b;
  output [`W-1:0] bus_out;
  input sel;
  mux2 mux0(bus_out[0], a[0],b[0], sel);
  mux2 mux1(bus_out[1], a[1],b[1], sel);
  mux2 mux2(bus_out[2], a[2],b[2], sel);
  mux2 mux3(bus_out[3], a[3],b[3], sel);
  mux2 mux4(bus_out[4], a[4],b[4], sel);  
  mux2 mux5(bus_out[5], a[5],b[5], sel);  
  mux2 mux6(bus_out[6], a[6],b[6], sel);  
  mux2 mux7(bus_out[7], a[7],b[7], sel);  
  mux2 mux8(bus_out[8], a[8],b[8], sel);  
  mux2 mux9(bus_out[9], a[9],b[9], sel);  
  mux2 muxa(bus_out[10],a[10],b[10], sel);  
  mux2 muxb(bus_out[11],a[11],b[11], sel);  
  mux2 muxc(bus_out[12],a[12],b[12], sel);  
  mux2 muxd(bus_out[13],a[13],b[13], sel);  
  mux2 muxe(bus_out[14],a[14],b[14], sel);  
endmodule


module compute_precond(precond,z,sub_mode);
  input [`W-1:0] z;
  input sub_mode;
  output [`W-1:0] precond;
  wire [`W-1:0] t,t2;

  //wire [10:0] negz11 = -z[10:0];
  wire [10:0] negz11;
  incrementor11 inc(negz11, ~z[10:0], 1'b1);

  //wire [`W-1:0] t = ((&z[`W-1:`F+1])==0) ? 5<<(`F-3):        //  0.625
  //            (15'h6000|(z >> 2)) + (9 << (`F-3));//  .25*z + 9/8
  //assign precond = (sub_mode==0) ? negz11[10:3] : t ;// -.125*z 
  //wire [`W-1:0] t2 = (15'h6000|(z >> 2)) + (9 << (`F-3));   //  .25*z + 9/8

  add15 pre_add(t2, {2'b11,z[`W-1:2]}, (15'h9 << (`F-3)), 1'b0); // .25*z + 9/8
  wire sel = &z[`W-1:`F+1];
  precond_mux mx1(t, 15'h5<<(`F-3),        //  0.625
                     t2, sel);
  precond_mux mx2(precond, {7'b0,negz11[10:3]}, t, sub_mode);
endmodule

module compute_postcond(postcond,z,sub_mode);
  input [`W-1:0] z;
  input sub_mode;
  output [`W-1:0] postcond;

  //wire [`W-2:0] negz = -z[`W-2:0];
  //assign postcond = negz >=     (3<<`F) ? 0:
  //                  negz <= (3<<(`F-2)) ? -(1<<(`F-6)) :
  //                                        +(1<<(`F-6));
  //always @(postcond) #100 $display("post=%h %b %b",postcond,postinc,postdec);

  wire nonzero = (&z[`W-2:`F+2]) & (|z[`F+1:`F]);
  wire smallz  = (&z[`W-2:`F])   & (|z[`F-1:`F-2]);
  wire postinc = (~smallz) & nonzero & (~sub_mode);
  wire postdec = ( smallz) & nonzero & (~sub_mode);
  assign postcond = {postdec,postdec,postdec,postdec,
                     postdec,postdec,postdec,postdec,
                     postdec,postdec,postdec,postdec,
                     postdec,postdec|postinc,1'b0};

endmodule

/*
module adjust_postcond(sbdb_temp2,sbdb_temp,z,sub_mode);
  output [`F:0] sbdb_temp2;
  input [`F:0] sbdb_temp;
  input [`W-1:0] z;
  input sub_mode;
  wire [`W-1:0] postcond;
  wire [`W-1:0] sbdb_temp2l;

  compute_postcond post_comp(postcond,z,sub_mode);
  add15 pos_add(sbdb_temp2l,{7'b0,sbdb_temp},postcond, 1'b0);
  assign sbdb_temp2 = sbdb_temp2l[`F:0];
endmodule

module inc7(sbdb_temp2h,sbdb_temph,postinc);
  output [`F-1:0] sbdb_temp2h; //"h" is high 7 bits of [7:0][`F:0]
  input [`F-1:0] sbdb_temph;
  input postinc;

  assign sbdb_temp2h = sbdb_temph + postinc;
endmodule
module dec7(sbdb_temp2h,sbdb_temph,postdec);
  output [`F-1:0] sbdb_temp2h; //"h" is high 7 bits of [7:0][`F:0]
  input [`F-1:0] sbdb_temph;
  input postdec;

  assign sbdb_temp2h = sbdb_temph - postdec;
endmodule
*/


module adjust_postcond(sbdb_temp2,sbdb_temp,z,sub_mode);
  output [`F:0] sbdb_temp2;
  input [`F:0] sbdb_temp;
  input [`W-1:0] z;
  input sub_mode;
  wire [`F-1:0] sbdb_temp1,sbdb_temp3;

  wire nonzero = (&z[`W-2:`F+2]) & (|z[`F+1:`F]);
  wire smallz  = (&z[`W-2:`F])   & (|z[`F-1:`F-2]);
  wire postinc = (~smallz) & nonzero & (~sub_mode);
  wire postdec = ( smallz) & nonzero & (~sub_mode);

  incrementor7 pos_inc(sbdb_temp1, sbdb_temp[`F:1],postinc);
  incrementor7 pos_dec(sbdb_temp3,~sbdb_temp1,     postdec);
  assign sbdb_temp2 = {~sbdb_temp3,sbdb_temp[0]};
endmodule


module novel_sbdb(sbdb_z, z, sub_mode);
  input [`W-1:0] z;
  output [`WORDSIZE-1:0] sbdb_z;
  input sub_mode;
  //wire [`W-1:0] sbdb_z_predec;
  wire [`W-1:0] precond;
  wire [`F:0] sbdb_temp;
  wire [`W-1:0] sbdb_small_z;
  wire [`W-1:0] temp2;
  wire [`W-1:0] sbdb_z_temp;
  wire [`F:0] sbdb_temp2;

  //incrementor inc(temp, z, sub_mode);
  //db_small_z small_db_table(sbdb_small_z, z[`F-1:0]);
  //assign temp = (sub_mode) ? z + (1<<`F) : z;
  //assign sbdb_z = (sub_mode & (&z[`W-1:`F])) ? sbdb_small_z : sbdb_temp;
  //decrementor db_fix(sbdb_z[`W-1:0], sbdb_z_predec, z, sub_mode);
  //assign sbdb_z[`W-1:`F] = sbdb_z_predec[`W-1:`F];
  //assign sbdb_z = {1'b0,sbdb_temp};

   
  db_small_z_rom small_db_table(sbdb_small_z, z[`F-1:0]);
  compute_precond pre_comp(precond,z,sub_mode);
  add15 pre_add(temp2, z, precond,1'b0);
  mitchell mit1(sbdb_temp, temp2);
  adjust_postcond pos_adj(sbdb_temp2,sbdb_temp,z,sub_mode);
  sbdb_mux novel_mux(sbdb_z_temp, {7'b0,sbdb_temp2}, 
                     sbdb_small_z, sub_mode, z);
  negate15 neg1(sbdb_z[`W-1:0],sbdb_z_temp,sub_mode);
  assign sbdb_z[`WORDSIZE-1] = 1'b0;  
endmodule

module lpvip(sbdb_z2, z2);
  input [`WORDSIZE-1:0] z2;
  output [`WORDSIZE-1:0] sbdb_z2;
  wire [`WORDSIZE-1:0] sbdb_z;

  wire notzero = z2 != 15'h4000;

  wire [`W-1:0] negz2 = -z2[`W-2:0];
  wire [`W-1:0] z1 = z2[`W-1] ?  {notzero,negz2[`W-2:0]} :
                                 {notzero,   z2[`W-2:0]};
  wire [`W-1:0] oldz = z2[`W-1] ? {1'b0,z2[`W-2:0]} : 0;

  novel_sbdb lpvip_instance(sbdb_z, z1, z2[`W]);

  assign sbdb_z2[`W-1:0] = sbdb_z + oldz[`W-1:0] + 15'h4000;
  assign sbdb_z2[`W] = sbdb_z[`W] ^( z2[15]&z2[14] );
endmodule
