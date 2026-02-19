module OneShot(
    input   din,
    output  dout
);
    parameter buffer_chain = 3;
    wire  [buffer_chain:0] w;
    
    CLKINVX8  CKINV  (.A(din),       .Y(w[0]));
    CLKBUFX1  CKBUF0 (.A(w[0]),      .Y(w[1]));
    CLKBUFX1  CKBUF1 (.A(w[1]),      .Y(w[2]));
    CLKBUFX1  CKBUF2 (.A(w[2]),      .Y(w[3]));
    CLKAND2X2 CKAND  (.A(din),       .B(w[3]),      .Y(dout));
endmodule
