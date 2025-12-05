module fmaalign(
    input logic [4:0] Ze, Xe, Ye, 
    input logic [10:0] Zm, 
    input logic XZero, YZero, ZZero,
    output logic [35:0] Am, //Should this be like 34? I have it where Nf = 10 36
    output logic ASticky, KillProd);

    logic [6:0] Acnt;
    logic KillZ;
    logic [45:0] ZmPreShifted;
    logic [45:0] ZmShifted;//13+11+22

    assign Acnt = ({2'b0, Xe} + {2'b0, Ye} - 7'd15) - {2'b0, Ze} + 7'd13;//has to be 7'd13 because (Ne+2)'d(Nf+3) //I believe this is an add
    
    assign KillZ = $signed(Acnt) > 35;
    
    assign ZmPreShifted = {Zm, 35'b0};

    assign KillProd = (Acnt[6] & ~ZZero)|XZero|YZero;//Checking if Acnt < 0 as well

    always_comb begin
        if (KillProd) begin
            ZmShifted = {13'b0, Zm, 22'b0};
            ASticky = ~(XZero|YZero);
        end
        else if (KillZ) begin
            ZmShifted = '0;
            ASticky = ~ZZero;
        end
        else begin
            ZmShifted = ZmPreShifted >> Acnt;
            ASticky = |(ZmShifted[9:0]);
        end
    end
    /*assign ZmShifted = (KillProd) ? {13'b0, Zm, 22'b0} : ((KillZ) ? 44'b0 : ({ZmPreShifted, 31'b0} >> Acnt)); 
    
    assign ASticky =  (KillProd) ? ~(XZero | YZero) : ((KillZ) ? ~ZZero : |(ZmShifted[9:0]));
    */
    assign Am = ZmShifted[45:10];// >> 10;

endmodule