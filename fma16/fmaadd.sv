module fmaadd(
    input logic [33:0] Am, 
    input logic [21:0] Pm, 
    input logic [4:0] Ze, 
    input logic [6:0] Pe, 
    input logic Ps, KillProd, ASticky, InvA,
    output logic [21:0] PmKilled, 
    output logic [33:0] Sm, AmInv,
    output logic [6:0] Se,
    output logic Ss);

    logic [33:0] PreSum, NegPreSum;
    logic NegSum;

    assign AmInv = (~InvA) ? Am : ~Am;
    assign PmKilled = Pm & ~KillProd;
    assign PreSum = PmKilled + AmInv + (~ASticky | KillProd) & InvA;
    assign NegPreSum = Am + ~PmKilled + (~ASticky | ~KillProd);
    assign NegSum = NegPreSum[33];

    assign Ss = Ps ^ NegSum;
    assign Se = (~KillProd) ? Pe : Ze;
    assign Sm = (~NegSum) ? PreSum : NegPreSum;

endmodule