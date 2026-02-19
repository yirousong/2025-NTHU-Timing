module PD (
    input  clk_in,
    input  FB,
    input  enable,
    output lead_lag
);
    wire   dummy, lead_lag_n;
    wire   A, B, S, R;
    wire   reset, self_reset;

    // DFF
    DFFRHQX4 FF1  (.D(1'b1),       .CK(FB),         .Q(A),      .RN(reset));
    DFFRHQX4 FF2  (.D(1'b1),       .CK(clk_in),     .Q(B),      .RN(reset));

    // Racing Circuit
    NAND2XL NAND1 (.A(A),          .B(R),           .Y(S)                 );
    NAND2XL NAND2 (.A(S),          .B(B),           .Y(R)                 );

    // Low-Active Circuit
    NAND2XL NAND3 (.A(S),          .B(lead_lag_n),  .Y(lead_lag)          );
    NAND2XL NAND4 (.A(lead_lag),   .B(R),           .Y(lead_lag_n)        );

    // Reset Signal
    NAND2XL NAND5 (.A(A),          .B(B),           .Y(self_reset)        );
    NAND2XL NAND6 (.A(B),          .B(A),           .Y(dummy)             );
    AND2X4  AND1  (.A(self_reset), .B(enable),      .Y(reset)             );

endmodule