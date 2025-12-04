module fmaalign(
    input logic [4:0] Ze, Xe, Ye, 
    input logic [10:0] Zm, 
    input logic XZero, YZero, ZZero,
    output logic [33:0] Am, //Should this be like 34? I have it where Nf = 10
    output logic ASticky, KillProd);

    logic [6:0] Acnt;
    logic KillZ;
    logic [43:0] ZmPreShifted;
    logic [43:0] ZmShifted;//13+11+22

    assign Acnt = ({2'b0, Xe} + {2'b0, Ye} - 7'd15) - {2'b0, Ze} + 7'd12;//(Xe + Ye - 15) - Ze + 12; //I believe this is an add
    assign KillZ = Acnt > 33;
    assign ZmPreShifted = {33'b0, Zm} << 12;

    assign KillProd = (Acnt < 0) | XZero | YZero;//Checking if Acnt < 0 as well

    assign ZmShifted = (KillProd) ? {12'b0, Zm, 21'b0} : ((KillZ) ? 44'b0 : ZmPreShifted >> Acnt); 
    
    assign ASticky =  (KillProd) ? ~(XZero | YZero) : ((KillZ) ? ~ZZero : |(ZmShifted[9:0]));
    
    assign Am = ZmShifted >> 10;

endmodule