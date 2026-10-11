`define xlns16_F 7
`define xlns16_logmask 16'h7fff
`define xlns16_esszer 2000
`define xlns16_logsignmask 16'h4000
`define xlns16_signmask 16'h8000

  function [15:0] xlns16_mitch;
   input [15:0] z;
   begin
    xlns16_mitch = ((1<<`xlns16_F)+(z&((1<<`xlns16_F)-1))) >> (8'hff&(-(z>>`xlns16_F)));
   end
  endfunction
      
  `include "lpvipsingcase.v"

  function [15:0] lpvip;
   input [15:0] z2;
   
   reg [15:0] z1,z,usedb, precond, postcond, mitch, adjust, oldz;
   reg flipsign;
   begin
    if ((z2[15:8]==8'b10111111)|(z2[15:8]==8'b11000000)) 
    begin
      lpvip = lpvipsing(z2);
    end
    else
     begin
    flipsign = z2[15]&z2[14];
    usedb = z2[15];// & `xlns16_signmask;
    z1 = (z2 & `xlns16_logmask) ^ `xlns16_logsignmask;
    if ((z1[14]==0))// & `xlns16_logsignmask)==0)
      begin
        oldz = z1;
        z = (-z1);
      end
    else
      begin
        oldz = 0;
        z = z1;
      end
    //$display("z=%h old=%h udb=%h ",z,oldz,usedb);
    precond = (usedb==0) ? (
                            ((16'h7fff&(-z))>>3)
                           ) :          // -.125*z 
              (z < -(2<<`xlns16_F)) ? 5<<(`xlns16_F-3):        //  0.625
                              (z >> 2) + (9 << (`xlns16_F-3));//  .25*z + 9/8
    //$display("precond=%h",precond);
    postcond = ((`xlns16_logmask&(-z)) >= (3<<`xlns16_F)) ? 0: 
                (`xlns16_logmask&(-z)) <= (3<<(`xlns16_F-2)) ? 
                                             -(1<<(`xlns16_F-6)) : 
                                             +(1<<(`xlns16_F-6));
    //$display("postcond=%h",postcond);
    //mitch = ((`xlns16_logmask&(-z)) >= 1<<`xlns16_F)||(usedb==0) ? xlns16_mitch((z+precond)) : 
     //             -xlns16_db_ideal(-z)-z; // use ideal for singularity
    mitch = xlns16_mitch((z+precond)); 
    //$display("pre=%h post=%h mit=%h",precond,postcond,mitch);
    adjust = usedb ? /*16'hffff&*/(-mitch) : 
            (z==0) ? 1<<`xlns16_F : mitch + postcond;
    //$display("adj=%h",adjust);
    lpvip = ((`xlns16_logmask&(-z)) > `xlns16_esszer) ? `xlns16_logsignmask + oldz:
                                    `xlns16_logsignmask + adjust + oldz;
    
    lpvip[15] = lpvip[15] ^ flipsign;
    end 
   end
  endfunction

