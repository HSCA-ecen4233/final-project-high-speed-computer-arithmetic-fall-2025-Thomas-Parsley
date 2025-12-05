module lzc (input logic [35:0] num, output logic [6:0] ZeroCnt);

  integer i;
  
  always_comb begin
    i = 0;
    while ((i < 36) & ~num[35-i]) i = i+1;  // search for leading one
    ZeroCnt = i[6:0];
  end
endmodule

module normalizer(input logic [35:0] Sm, input logic [6:0] Se, ZeroCnt, output logic [35:0] SmNorm, output logic [6:0] SeNorm);

  always_comb begin
    if (Sm == 0) begin
      SmNorm = 36'b0;
      SeNorm = 7'b0;   // exponent for zero
    end else begin
      SmNorm = Sm << ZeroCnt;
      SeNorm = Se - ZeroCnt + 7'd13;
    end
  end

endmodule