`define xlns16_F 15
`define xlns16_logmask 24'h7fffff
`define xlns16_esszer 512000
`define xlns16_logsignmask 24'h400000
`define xlns16_signmask 24'h800000

  function [23:0] xlns16_mitch;
   input [23:0] z;
   begin
    xlns16_mitch = ((1<<`xlns16_F)+(z&((1<<`xlns16_F)-1))) >> (8'hff&(-(z>>`xlns16_F)));
   end
  endfunction
      
  //`include "lpvipsingcase.v"

  function [23:0] lpvip;
   input [23:0] z2;
   
   reg [23:0] z1,z, precond, postcond, mitch, adjust, oldz;
    reg usedb;
   reg flipsign;
   begin
    /*if ((z2[23:16]==8'b10111111)|(z2[23:16]==8'b11000000)) 
    begin
      lpvip = 0;//lpvipsing(z2>>8)<<8;
    end
    else*/
     begin
    flipsign = z2[23]&z2[22];
    usedb = z2[23];// & `xlns16_signmask;
    z1 = (z2 & `xlns16_logmask) ^ `xlns16_logsignmask;
    /*if ((z1[22]==0))// & `xlns16_logsignmask)==0)
      begin
        oldz = z1;
        z = (-z1);
      end
    else*/
      begin
        oldz = 0;
        z = z1;
      end
    //$display("z=%h old=%h udb=%h ",z,oldz,usedb);
    precond = (usedb==0) ? (
                            ((24'h7fffff&(-z))>>3)
                           ) :          // -.125*z 
              (z < -(2<<`xlns16_F)) ? 5<<(`xlns16_F-3):        //  0.625
                              (z >> 2) + (9 << (`xlns16_F-3));//  .25*z + 9/8

    //$display("precond=%h",precond);
    postcond = ((`xlns16_logmask&(-z)) >= (3<<`xlns16_F)) ? 0: 
                (`xlns16_logmask&(-z)) <= (3<<(`xlns16_F-2)) ? 
                                             -(1<<(`xlns16_F-6)) : 
                                             +(1<<(`xlns16_F-6));
    //$display("postcond=%h",postcond);
       mitch = xlns16_mitch((z+precond)); 
    //$display("pre=%h post=%h mit=%h",precond,postcond,mitch);
    adjust = usedb ? /*16'hffff&*/(-mitch) : 
       (z==0) ? 1<<`xlns16_F : mitch + postcond;
    //$display("adj=%h",adjust);
    lpvip = ((`xlns16_logmask&(-z)) > `xlns16_esszer) ? `xlns16_logsignmask + oldz:
                                    `xlns16_logsignmask + adjust + oldz;
    
    lpvip[23] = lpvip[23] ^ flipsign;
    end 
   end
  endfunction

