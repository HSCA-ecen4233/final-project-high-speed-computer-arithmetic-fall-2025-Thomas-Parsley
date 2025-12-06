module round(
    input logic Ss, 
    input logic [6:0] Se,
    input logic [35:0] Sm,
    input logic ASticky,
    input logic [1:0] RndMode,
    input logic ZZero, Zs,
    output logic [15:0] result);

    logic G, R, S, L, Rnd;
    logic [11:0] MidSm;
    logic [9:0] OutSm;
    logic [6:0] OutSe;

    assign G = Sm[24];
    assign R = Sm[23];
    assign S = |Sm[22:0];
    assign L = Sm[25];

    assign Rnd = G & (L | S | R);

    always_comb begin
        if (RndMode == 2'b00) begin
            OutSm = Sm[34:25];
            OutSe = Se;
            //result = {Ss, Se[4:0], Sm[34:25]};
        end
        else begin
            MidSm = {1'b0, Sm[35:25]} + Rnd;
            OutSm = (MidSm[11]) ? MidSm[10:1] : MidSm[9:0];
            OutSe = (MidSm[11]) ? Se + 7'd1 : Se;

            //result = {Ss, OutSe[4:0], OutSm[9:0]};
        end

        if (RndMode == 2'b00) begin
            result = {(((Sm != 0)|(Zs&ZZero))? Ss : 1'b0), Se[4:0], Sm[34:25]};
        end
        else begin
            result = {(((Sm != 0)|(Zs&ZZero))? Ss : 1'b0), OutSe[4:0], OutSm};
        end
    end/**/
endmodule