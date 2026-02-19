module DCO(
    input       enable,
    input [7:0] lambda,
    output wire dco_clk
);

    wire  [6:0] c;

    parameter buffer_chain = 2;
    wire  [buffer_chain:0] d;

    NAND2XL N0(.A(enable), .B(dco_clk), .Y(d[buffer_chain]));

    MX2X2 M0(.A(c[0]), .B(d[0]), .Y(dco_clk), .S0(lambda[0]));
    MX2X2 M1(.A(c[1]), .B(d[0]), .Y(c[0]),    .S0(lambda[1]));
    MX2X2 M2(.A(c[2]), .B(d[0]), .Y(c[1]),    .S0(lambda[2]));
    MX2X2 M3(.A(c[3]), .B(d[0]), .Y(c[2]),    .S0(lambda[3]));
    MX2X2 M4(.A(c[4]), .B(d[0]), .Y(c[3]),    .S0(lambda[4]));
    MX2X2 M5(.A(c[5]), .B(d[0]), .Y(c[4]),    .S0(lambda[5]));
    MX2X2 M6(.A(c[6]), .B(d[0]), .Y(c[5]),    .S0(lambda[6]));
    MX2X2 M7(.A(1'b0), .B(d[0]), .Y(c[6]),    .S0(lambda[7]));

    genvar i;    

    generate
        for (i = 0; i < buffer_chain; i = i + 1) begin:loop1
            BUFX2 B0( .A (d[i+1]), .Y (d[i]) );
        end
    endgenerate

endmodule

// module DCO(enable, lambda, dco_clk);
//     input enable;
//     input [3:0] lambda;
//     output wire dco_clk;

//     wire [2:0] c;
//     parameter buffer_chain = 10'd4;
//     wire [buffer_chain:0] d;

//     NAND2XL F0(.A(enable) ,.B(dco_clk) ,.Y(d[buffer_chain]));

//     MX2X2 B0(.A(c[0]), .B(d[0]), .Y(dco_clk), .S0(lambda[0]));
//     MX2X2 B1(.A(c[1]), .B(d[1]), .Y(c[0]), .S0(lambda[1]));
//     MX2X2 B2(.A(c[2]), .B(d[2]), .Y(c[1]), .S0(lambda[2]));
//     MX2X2 B3(.A(1'b0), .B(d[3]), .Y(c[2]), .S0(lambda[3]));

//     genvar i;    

//     generate
//         for (i = 0; i < buffer_chain; i = i + 1) begin:loop1
//             BUFX2 C1( .A (d[i+1]), .Y (d[i]) );
//         end
//     endgenerate

// endmodule


