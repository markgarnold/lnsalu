//////////
//F=7 
`define F 7
`define W 15
`define WORDSIZE `W+1

`define MUXDELAY 2
`define GATEDELAY 1


module tally;
  integer or_count;
  integer and_count;
  integer xor_count;
  integer mux2_count;
  integer or_activity;
  integer and_activity;
  integer xor_activity;
  integer mux2_activity;

  integer lasttime;
  initial lasttime = 0;

  initial or_count = 0;
  initial and_count = 0;
  initial xor_count = 0;
  initial mux2_count = 0;
  
  initial or_activity = 0;
  initial and_activity = 0;
  initial xor_activity = 0;
  initial mux2_activity = 0;
initial $display("lpvip2_gate_tally.v");
  
  task print;
    begin
         $display("and_count=",and_count);
         $display("or_count=",or_count);
         $display("xor_count=",xor_count);
         $display("mux2_count=",mux2_count);
         $display((1.0*and_count+1.0*or_count+3.0*xor_count+3.0*mux2_count));
         $display("and_activity=",and_activity);
         $display("or_activity=",or_activity);
         $display("xor_activity=",xor_activity);
         $display("mux2_activity=",mux2_activity);
         $display("total=",and_activity+or_activity+3*xor_activity+3*mux2_activity);
         $display("avg=", (1.0*and_activity+1.0*or_activity+3.0*xor_activity+3.0*mux2_activity)/
                          (1.0*and_count+1.0*or_count+3.0*xor_count+3.0*mux2_count));
    end
  endtask

  task fprint;
    input f;
    integer f;
    real avg;
    integer iavg;
    begin
         $fdisplay(f,"and_count=",and_count);
         $fdisplay(f,"or_count=",or_count);
         $fdisplay(f,"xor_count=",xor_count);
         $fdisplay(f,"mux2_count=",mux2_count);
         $fdisplay(f,and_count+or_count+3*xor_count+3*mux2_count);
         $fdisplay(f,"and_activity=",and_activity);
         $fdisplay(f,"or_activity=",or_activity);
         $fdisplay(f,"xor_activity=",xor_activity);
         $fdisplay(f,"mux2_activity=",mux2_activity);
         $fdisplay(f,"total=",and_activity+or_activity+3*xor_activity+3*mux2_activity);
         avg = (1.0*and_activity+1.0*or_activity+3.0*xor_activity+3.0*mux2_activity)/
                             (1.0*and_count+1.0*or_count+3.0*xor_count+3.0*mux2_count);
         iavg = avg;
         $fdisplay(f,"avg=", iavg);
    end
  endtask
endmodule


module my_or(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.or_count = tally.or_count + 1;

  always @(a)
    tally.or_activity = tally.or_activity + 1;
  always @(b)
    tally.or_activity = tally.or_activity + 1;
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  or #(`GATEDELAY) builtin(o,a,b);
  //assign o = a | b;
endmodule

module inc_or(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.or_count = tally.or_count + 1;

  always @(a)
    tally.or_activity = tally.or_activity + 1;
  always @(b)
    tally.or_activity = tally.or_activity + 1;
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  or #(`GATEDELAY) builtin(o,a,b);
  //assign o = a | b;
endmodule


module max_or(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.or_count = tally.or_count + 1;

  always @(a)
    tally.or_activity = tally.or_activity + 1;
  always @(b)
    tally.or_activity = tally.or_activity + 1;
    
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  or #(`GATEDELAY) builtin(o,a,b);
  //assign o = a | b;
endmodule


module my_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
        
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule

module mit_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
        
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule

module sbdb_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
        
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule

module small_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule


module inc_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
        
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule


module sub_and(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.and_count = tally.and_count + 1;

  always @(a)
    tally.and_activity = tally.and_activity + 1;
  always @(b)
    tally.and_activity = tally.and_activity + 1;
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  and #(`GATEDELAY) builtin(o,a,b);
  //assign o = a & b;
endmodule


module sub_xor(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.xor_count = tally.xor_count + 1;

  always @(a)
    tally.xor_activity = tally.xor_activity + 1;
  always @(b)
    tally.xor_activity = tally.xor_activity + 1;
    
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  xor #(`GATEDELAY) builtin(o,a,b);
  //assign o = a ^ b//;
endmodule

module my_xor(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.xor_count = tally.xor_count + 1;

  always @(a)
    tally.xor_activity = tally.xor_activity + 1;
  always @(b)
    tally.xor_activity = tally.xor_activity + 1;
    
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  xor #(`GATEDELAY) builtin(o,a,b);
  //assign o = a ^ b;
endmodule

module inc_xor(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.xor_count = tally.xor_count + 1;

  always @(a)
    tally.xor_activity = tally.xor_activity + 1;
  always @(b)
    tally.xor_activity = tally.xor_activity + 1;
    
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  xor #(`GATEDELAY) builtin(o,a,b);
  //assign o = a ^ b;
endmodule

module dec_xor(o,a,b);
  input a,b;
  output o;
  
  initial
    #0 tally.xor_count = tally.xor_count + 1;

  always @(a)
    tally.xor_activity = tally.xor_activity + 1;
  always @(b)
    tally.xor_activity = tally.xor_activity + 1;
    
    
  always @(a or b)
    begin
      #`GATEDELAY tally.lasttime = $time;
    end

  xor #(`GATEDELAY) builtin(o,a,b);
  //assign o = a ^ b;
endmodule


module mux2(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  initial
    #0 tally.mux2_count = tally.mux2_count + 1;

  always @(i1)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(i0)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(sel)
    tally.mux2_activity = tally.mux2_activity + 1;

  always @(i1 or i0 or sel)
    begin
      #`MUXDELAY tally.lasttime = $time;
    end

  assign #(`MUXDELAY) out = (sel)? i1 : i0;  
endmodule


module mux2_sbdb(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  initial
    #0 tally.mux2_count = tally.mux2_count + 1;

  always @(i1)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(i0)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(sel)
    tally.mux2_activity = tally.mux2_activity + 1;

  always @(i1 or i0 or sel)
    begin
      #`MUXDELAY tally.lasttime = $time;
    end

  assign #(`MUXDELAY) out = (sel)? i1 : i0;  
endmodule

module mux2_small(out, i0, i1, sel);
  input i0, i1, sel;
  output out;
  wire t0,t1;

  initial
    #0 tally.mux2_count = tally.mux2_count + 1;

  always @(i1)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(i0)
    tally.mux2_activity = tally.mux2_activity + 1;
  always @(sel)
    tally.mux2_activity = tally.mux2_activity + 1;

  always @(i1 or i0 or sel)
    begin
      #`MUXDELAY tally.lasttime = $time;
    end

  assign #(`MUXDELAY) out = (sel)? i1 : i0;  
endmodule

/////////////////////////////////////////////////////////////////////
