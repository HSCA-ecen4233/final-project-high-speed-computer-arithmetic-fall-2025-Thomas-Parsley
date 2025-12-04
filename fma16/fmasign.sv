module fmasign(input logic Xs, Ys, Zs, output logic Ps, As, InvA);

    assign Ps = Xs ^ Ys;
    assign As = Zs; //decides add or sub
    assign InvA = Ps ^ As;

endmodule