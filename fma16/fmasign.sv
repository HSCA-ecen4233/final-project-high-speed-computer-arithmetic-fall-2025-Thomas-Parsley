module fmasign(input logic OpCtrl, Xs, Ys, Zs, output logic Ps, As, InvA);

    assign Ps = Xs ^ Ys;
    assign As = Zs ^ OpCtrl; //decides add or sub
    assign InvA = Ps ^ As;

endmodule;