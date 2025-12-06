module fmaflags (input logic Xs, Ys, Zs, Xsnan, Ysnan, Zsnan, Xnan, Ynan, Znan, Xinf, Yinf, Zinf, XZero, YZero, ZZero, ASticky, 
                input logic [1:0] roundmode, 
                input logic [35:0] Smnorm, 
                input logic [6:0] Senorm, 
                input logic [15:0] MidResult,
                output logic [15:0] AdjResult, 
                output logic [3:0] flags);

    logic flag_nv, flag_of, flag_uf, flag_nx;

    always_comb begin
        // At least one sNaN - result = NaN, flag_nv = 1
        if (Xsnan | Ysnan | Zsnan) begin
            AdjResult = 16'h7e00;
            flag_nv = 1'b1;
            flag_of = 1'b0;
        end
        // At least one NaN - result = NaN, flag_nv = 0
        else if (Xnan | Ynan | Znan) begin
            AdjResult = 16'h7e00;
            flag_nv = 1'b0;
            flag_of = 1'b0;
        end
        // At least one inf and Z is inf of opposite sign - result = NaN, flag_nv = 1
        else if ((Xinf | Yinf) & Zinf & (Xs^Ys^Zs)) begin
            AdjResult = 16'h7e00;
            flag_nv = 1'b1;
            flag_of = 1'b0;
        end
        // One 0 and one inf with normal Z - result = NaN, flag_nv = 1
        else if ((Xinf & YZero) | (XZero & Yinf)) begin
            AdjResult = 16'h7e00;
            flag_nv = 1'b1;
            flag_of = 1'b0;
        end
        // At least one inf - result = inf, flag_nv = 0
        else if (Xinf | Yinf) begin
            AdjResult = {Xs^Ys, 5'h1f, 10'b0};
            flag_nv = 1'b0;
            flag_of = 1'b0;
        end
        // Z is inf - result = inf, flag_nv = 0
        else if (Zinf) begin
            AdjResult = {Zs, 5'h1f, 10'b0};
            flag_nv = 1'b0;
            flag_of = 1'b0;
        end
        // Take normal value
        else if ((&Senorm[4:0] | Senorm[5]) & ~Senorm[6]) begin
            flag_of = 1'b1;
            AdjResult = roundmode[0] ? {MidResult[15], 5'h1f, 10'b0} : {MidResult[15], 15'b111101111111111};
            flag_nv = 1'b0;
        end
        else begin
            AdjResult = MidResult;
            flag_nv = 1'b0;
            flag_of = 1'b0;
        end
    end

    assign flag_nx = (ASticky|Smnorm[24]|flag_of|Smnorm[23])&~(Xinf|Yinf|Zinf|Xnan|Ynan|Znan|flag_nv);
    assign flag_uf = ($signed(Senorm) <= 0) & ASticky;

    assign flags = {flag_nv, flag_of, flag_uf, flag_nx};

endmodule