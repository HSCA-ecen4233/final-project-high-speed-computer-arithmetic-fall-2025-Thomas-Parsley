module fmaalign(
    input logic [4:0] Ze, Xe, Ye, 
    input logic [10:0] Zm, 
    input logic XZero, YZero, ZZero,
    output logic [33:0] Am, //Should this be like 34? I have it where Nf = 10
    output logic ASticky, KillProd);

    logic [6:0] Acnt;
    logic KillZ;
    logic [12:0] ZmPreShifted;
    logic [43:0] ZmShifted;

    assign Acnt = (Xe + Ye - 15) - Ze + 10 + 2; //Is Nf the amount of bits of the mantissa????
    assign KillZ = Acnt > 33;
    assign ZmPreShifted = Zm << 12;
    assign ZmShifted = (KillProd) ? Zm : ((KillZ) ? 0 : ZmPreShifted >> Acnt); //You know, I have no clue if this is correct Im kinda just hoping

    assign KillProd = Acnt[6] | Xzero | Yzero;//Checking if Acnt < 0 as well
    assign ASticky =  (KillProd) ? ~(Xzero | Yzero) : ((KillZ) ? ~Zzero : |(ZmShifted[9:0]));
    assign Am = ZmShifted >> 10;

endmodule