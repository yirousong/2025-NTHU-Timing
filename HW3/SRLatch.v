module SRLatch (
    input  S,
    input  R,
    output Q,
    output Q_b
);

    // High-Active Circuit
    NOR2XL NOR0 (.A(R),     .B(Q_b),    .Y(Q)  );
    NOR2XL NOR1 (.A(Q),     .B(S),      .Y(Q_b));
endmodule