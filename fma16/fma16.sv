// fma16.sv
// David_Harris@hmc.edu 26 February 2022

// Operation: general purpose multiply, add, fma, with optional negation
//   If mul=1, p = x * y.  Else p = x.
//   If add=1, result = p + z.  Else result = p.
//   If negr or negz = 1, negate result or z to handle negations and subtractions
//   fadd: mul = 0, add = 1, negr = negz = 0
//   fsub: mul = 0, add = 1, negr = 0, negz = 1
//   fmul: mul = 1, add = 0, negr = 0, negz = 0
//   fmadd:  mul = 1, add = 1, negr = 0, negz = 0
//   fmsub:  mul = 1, add = 1, negr = 0, negz = 1
//   fnmadd: mul = 1, add = 1, negr = 1, negz = 0
//   fnmsub: mul = 1, add = 1, negr = 1, negz = 1

module fma16 (x, y, z, mul, add, negr, negz,
	      roundmode, result, flags);
   
   input logic [15:0]  x, y, z;   
   input logic 	       mul, add, negr, negz;
   input logic [1:0]   roundmode;
   
   output logic [15:0] result;
   output logic [3:0]  flags;

   logic [4:0] 	       Xe, Ye, Ze;
   logic [10:0] 	       Xm, Ym, Zm; //Orginally was 9. Should the unpack add the extra bit?
   logic 	       Xs, Ys, Zs;

   logic 	       Xsubnorm, Xzero, Xinf, XNaN, XsNaN;
   logic 	       Ysubnorm, Yzero, Yinf, YNaN, YsNaN;
   logic 	       Zsubnorm, Zzero, Zinf, ZNaN, ZsNaN;

   //Intermediate Signals
   logic [6:0] Pe, Se; //expadd, add
   logic [21:0] Pm, PmKilled; //mult, add
   logic Ps, As, InvA, ASticky, KillProd, Ss; //sign, align, add
   logic [33:0] Am, AmInv, Sm; //align, add

   unpack upX(.X(x), .Xsubnorm(Xsubnorm), .Xzero(Xzero), .Xinf(Xinf), .XNaN(XNaN), .XsNaN(XsNaN), .Xs(Xs), .Xe(Xe), .Xm(Xm));
   unpack upY(.X(y), .Xsubnorm(Ysubnorm), .Xzero(Yzero), .Xinf(Yinf), .XNaN(YNaN), .XsNaN(YsNaN), .Xs(Ys), .Xe(Ye), .Xm(Ym));
   unpack upZ(.X(z), .Xsubnorm(Zsubnorm), .Xzero(Zzero), .Xinf(Zinf), .XNaN(ZNaN), .XsNaN(ZsNaN), .Xs(Zs), .Xe(Ze), .Xm(Zm));

   // stubbed ideas for instantiation ideas
   
   // fmaexpadd expadd(.Xe, .Ye, .XZero, .YZero, .Pe);
   fmaexpadd expadd(.Xe(Xe), .Ye(Ye), .XZero(Xzero), .YZero(Yzero), .Pe(Pe));

   // fmamult mult(.Xm, .Ym, .Pm);
   fmamult mult(.Xm(Xm), .Ym(Ym), .Pm(Pm));

   // fmasign sign(.OpCtrl, .Xs, .Ys, .Zs, .Ps, .As, .InvA);
   fmasign sign(.OpCtrl(negz), .Xs(Xs), .Ys(Ys), .Zs(Zs), .Ps(Ps), .As(As), .InvA(InvA));

   // fmaalign align(.Ze, .Zm, .XZero, .YZero, .ZZero, .Xe, .Ye, .Am, .ASticky, .KillProd);
   fmaalign align(.Ze(Ze), .Zm(Zm), .XZero(Xzero), .YZero(Yzero), .ZZero(Zzero), .Xe(Xe), .Ye(Ye), .Am(Am), .ASticky(ASticky), .KillProd(KillProd));

   // fmaadd add(.Am, .Pm, .Ze, .Pe, .Ps, .KillProd, .ASticky, .AmInv, .PmKilled, .InvA, .Sm, .Se, .Ss);
   fmaadd fadd(.Am(Am), .Pm(Pm), .Ze(Ze), .Pe(Pe), .Ps(Ps), .KillProd(KillProd), .ASticky(ASticky), .AmInv(AmInv), .PmKilled(PmKilled), .InvA(InvA), .Sm(), .Se(), .Ss());
   
   // fmalza lza (.A(AmInv), .Pm(PmKilled), .Cin(InvA & (~ASticky | KillProd)), .sub(InvA), .SCnt);//lzc (given) then shift the shifting amound from lzc

   //Test Stuff
   assign result = 16'b0;
   assign flags = 5'b0;

 
endmodule

