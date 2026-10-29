//////////
//F=7 
`define F 7
`define W 15
`define WORDSIZE `W+1


module my_or(o,a,b);
  input a,b;
  output o;
  
  assign o = a | b;
endmodule

module inc_or(o,a,b);
  input a,b;
  output o;
  
  assign o = a | b;
endmodule


module max_or(o,a,b);
  input a,b;
  output o;
  
  assign o = a | b;
endmodule


module my_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule

module mit_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule

module sbdb_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule

module small_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule


module inc_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule


module sub_and(o,a,b);
  input a,b;
  output o;
  
  assign o = a & b;
endmodule


module sub_xor(o,a,b);
  input a,b;
  output o;
  
  assign o = a ^ b;
endmodule

module my_xor(o,a,b);
  input a,b;
  output o;
  
  assign o = a ^ b;
endmodule

module inc_xor(o,a,b);
  input a,b;
  output o;
  
  assign o = a ^ b;
endmodule

module dec_xor(o,a,b);
  input a,b;
  output o;
  
  assign o = a ^ b;
endmodule


module mux2(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  assign out = (sel)? i1 : i0;  
endmodule


module mux2_sbdb(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  assign out = (sel)? i1 : i0;  
endmodule

module mux2_small(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  assign out = (sel)? i1 : i0;  
endmodule

/////////////////////////////////////////////////////////////////////
