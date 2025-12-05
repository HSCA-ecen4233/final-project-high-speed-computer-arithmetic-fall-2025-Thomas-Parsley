module fmaadd(
    input logic [35:0] Am, 
    input logic [21:0] Pm, 
    input logic [4:0] Ze, //add 2'b0 wherever
    input logic [6:0] Pe, 
    input logic Ps, KillProd, ASticky, InvA,
    output logic [21:0] PmKilled, 
    output logic [35:0] Sm, AmInv,
    output logic [6:0] Se,
    output logic Ss);

    logic [35:0] PreSum, NegPreSum;
    logic NegSum;

    logic [21:0] NotPmKilled;
    assign NotPmKilled = ~PmKilled;

    logic NotKillProd, NotASticky;
    assign NotKillProd = ~KillProd;
    assign NotASticky = ~ASticky;
    
    logic [35:0] NPSKilled, NPSSKprod;

    assign NPSKilled = {1'b1, 11'b0, ~PmKilled, 2'b0};
    assign NPSSKprod = {33'b0, (~ASticky | ~KillProd), 2'b0};

    logic NegBit;
    assign NegBit = (~ASticky | ~KillProd);



    assign AmInv = InvA ? ~Am : Am;
    assign PmKilled = KillProd ? 0 : Pm;
    //assign PreSum = {12'b0, PmKilled} + AmInv + {33'b0, ((~ASticky | KillProd) & InvA)};
    assign {NegSum, PreSum} = {13'b0, PmKilled, 2'b0} + {InvA, AmInv} + {35'b0, (~ASticky|KillProd)&InvA};
    //assign NegPreSum = Am + {12'b0, ~PmKilled} + {33'b0, (~ASticky | ~KillProd)};
    assign NegPreSum = Am + {12'b111111111111, ~PmKilled, 2'b0} + {33'b0, NegBit, 2'b0};
    //assign NegSum = NegPreSum[33];

    assign Ss = Ps ^ NegSum;
    assign Se = (KillProd) ? {2'b0, Ze} : Pe;
    assign Sm = (NegSum) ? NegPreSum : PreSum;

endmodule