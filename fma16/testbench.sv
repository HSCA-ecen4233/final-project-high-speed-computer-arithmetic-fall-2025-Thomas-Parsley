/* verilator lint_off STMTDLY */
module tb_fma16;
   logic        clk, reset;
   logic [15:0] x, y, z, rexpected, result;
   logic [7:0] 	ctrl;
   logic        mul, add, negp, negz;
   logic [1:0] 	roundmode;
   logic [31:0] vectornum, errors;
   logic [75:0] testvectors[30000:0];
   logic [3:0] 	flags, flagsexpected; // Invalid, Overflow, Underflow, Inexact
   
   integer 	handle3;
   
  // instantiate device under test
   fma16 dut(x, y, z, mul, add, negp, negz, roundmode, result, flags);
   
   // generate clock
   always 
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // Define the output file
   initial
     begin
	handle3 = $fopen("fma16.out");
	vectornum = 0;
	errors = 0;		
     end   

  // at start of test, load vectors and pulse reset
  initial
    begin
      $readmemh("tests/fma_2.tv", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #22; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {x, y, z, ctrl, rexpected, flagsexpected} = testvectors[vectornum];
      {roundmode, mul, add, negp, negz} = ctrl[5:0];
    end

   // check results on falling edge of clk
   always @(negedge clk)
     if (~reset) begin // skip during reset
	if (result !== rexpected /* | flags !== flagsexpected */) begin  // check result
           $fdisplay(handle3, "Error: inputs %h * %h + %h. RoundMode:", x, y, z, roundmode);
           $fdisplay(handle3, "  result = %h (%h expected) flags = %b (%b expected)", 
		     result, rexpected, flags, flagsexpected);
          
          /*$fdisplay(handle3, "");
          //UNPACK
          $fdisplay(handle3, " UnpackX || Xs: %b | Xe: %d : %h | Xm: %h : %b ||", dut.Xs, dut.Xe, dut.Xe, dut.Xm, dut.Xm);
          $fdisplay(handle3, " UnpackY || Ys: %b | Ye: %d : %h | Ym: %h : %b ||", dut.Ys, dut.Ye, dut.Ye, dut.Ym, dut.Ym);
          $fdisplay(handle3, " UnpackZ || Zs: %b | Ze: %d : %h | Zm: %h : %b ||", dut.Zs, dut.Ze, dut.Ze, dut.Zm, dut.Zm);

          $fdisplay(handle3, " UnpackX || Zero: %b | SubN: %b | Inf: %b | NaN: %b | sNaN: %b | ExpMax: %b ||", dut.Xzero, dut.Xsubnorm, dut.Xinf, dut.XNaN, dut.XsNaN, dut.upX.Xemax);
          $fdisplay(handle3, " UnpackY || Zero: %b | SubN: %b | Inf: %b | NaN: %b | sNaN: %b | ExpMax: %b ||", dut.Yzero, dut.Ysubnorm, dut.Yinf, dut.YNaN, dut.YsNaN, dut.upY.Xemax);
          $fdisplay(handle3, " UnpackZ || Zero: %b | SubN: %b | Inf: %b | NaN: %b | sNaN: %b | ExpMax: %b ||", dut.Zzero, dut.Zsubnorm, dut.Zinf, dut.ZNaN, dut.ZsNaN, dut.upZ.Xemax);

          //EXPADD
          $fdisplay(handle3, " Expadd || Pe: %h : %d ||", dut.Pe, dut.Pe);

          //MULT
          $fdisplay(handle3, " mult || Pm: %d : %h ||", dut.Pm, dut.Pm);

          //SIGN
          $fdisplay(handle3, " sign || Ps: %d : %h | As: %d : %h | InvA: %b ||", dut.Ps, dut.Ps, dut.As, dut.As, dut.InvA);

          //ALIGN
          $fdisplay(handle3, " align || Am: %d : %h | ASticky: %b | KillProd: %b ||", dut.Am, dut.Am, dut.ASticky, dut.KillProd);
          //$fdisplay(handle3, " align || Acnt: %d : %h | KillProd: %b | KillZ: %b | Zm: %h | ZmPre: %h | ZmShif: %h ||", dut.align.Acnt, dut.align.Acnt, dut.align.KillProd, dut.align.KillZ, dut.align.Zm, dut.align.ZmPreShifted, dut.align.ZmShifted);
          
          $fdisplay(handle3, " add || Sm: %d : %h | Se: %d : %h | Ss: %b ||", dut.Sm, dut.Sm, dut.Se, dut.Se, dut.Ss);
          //$fdisplay(handle3, " add || Am: %d : %h | ~PmKilled: %d : %h | ~ASticky: %b | ~KillProd: %b | NPSKilled: %h | NPSSKprod: %h ||", dut.fadd.Am, dut.fadd.Am, dut.fadd.NotPmKilled, dut.fadd.NotPmKilled, dut.fadd.NotASticky, dut.fadd.NotKillProd, dut.fadd.NPSKilled, dut.fadd.NPSSKprod);

          $fdisplay(handle3, " lzc || ZeroCnt: %d ||", dut.ZeroCnt);

          $fdisplay(handle3, " normalizer || SmNorm: %h | SeNorm: %h ||", dut.SmNorm, dut.SeNorm);

          $fdisplay(handle3, "");*/
          $fdisplay(handle3, " normalizer || Rnd: %b | G: %b | R: %b | S: %b | ASticky: %b ||", dut.round.Rnd, dut.flagss.g, dut.flagss.r, dut.flagss.s, dut.flagss.ASticky);
          $fdisplay(handle3, "------------------------------------------------------------------------");
          $fdisplay(handle3, "");/**/
          //$fdisplay(handle3, "Recieved || Pe: %h | Pm: %h | ", dut.Pe); //Other Things
           errors = errors + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 'x) begin 
           $fdisplay(handle3, "%d tests completed with %d errors", 
	             vectornum, errors);
           $stop;
	end
     end
endmodule
