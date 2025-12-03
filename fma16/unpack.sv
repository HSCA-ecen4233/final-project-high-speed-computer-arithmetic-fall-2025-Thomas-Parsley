module unpack(input logic [15:0] X, 
    output logic Xsubnorm, Xzero, Xinf, XNaN, XsNaN, Xs,
    output logic [4:0] Xe,
    output logic [10:0] Xm);

    // Intermediate Signals
    logic Xemax, Xenonzero, Xfzero;
    logic [9:0] Xf;

    assign Xemax = &X[14:10];
    assign Xenonzero = |X[14:10];
    assign Xf = X[9:0];
    assign Xfzero = ~(|Xf[9:0]);

    //Outputs
    assign Xs = X[15];
    assign Xe = X[14:10] + ~Xenonzero; //Add because its checking if its zero
    assign Xm = {Xenonzero, Xf[9:0]};
    assign Xsubnorm = ~Xenonzero & ~Xfzero;
    assign Xzero = ~Xenonzero & Xfzero;
    assign Xinf = Xemax & Xfzero;
    assign XNaN = Xemax & ~Xfzero;
    assign XsNaN = XNaN & ~Xf[9];

endmodule