module lzc (input logic [33:0] num, output logic [6:0] ZeroCnt);

  integer i;
  
  always_comb begin
    i = 0;
    while ((i < 34) & ~num[33-i]) i = i+1;  // search for leading one
    ZeroCnt = i[6:0];
  end
endmodule

module normalizer(input logic [33:0] Sm, input logic [6:0] Se, ZeroCnt, output logic [33:0] SmNorm, output logic [6:0] SeNorm);

  assign SmNorm = Sm << ZeroCnt;
  assign SeNorm = Se - ZeroCnt + 7'd11;

endmodule