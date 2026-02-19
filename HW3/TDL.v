module TDL(
    input       clk_in,
    input [7:0] lambda,
    output wire clk_out
);

    parameter TAPS = 8;

    wire [TAPS-1:0] d;   // delay taps
    wire [TAPS-1:0] sel; // mux selection chain

    // 第一個 tap = clk_in
    assign d[TAPS-1] = clk_in;

    // buffer chain (實現 delay)
    genvar i;
    generate
        for (i = TAPS-1; i > 0; i = i - 1) begin : delay_chain
            BUFX2 B0(.A(d[i]), .Y(d[i-1]));
        end
    endgenerate

    // MUX chain for selection
    // sel[i] = 要不要選 d[i]
    // 最後 clk_out = sel[0]
    generate
        for (i = 0; i < TAPS-1; i = i + 1) begin : mux_chain
            MX2X2 M0(
                .A(sel[i+1]),    // 下一層的輸出
                .B(d[i]),        // 對應 delay tap
                .Y(sel[i]),
                .S0(lambda[i])   // lambda 控制是否選取這個延遲
            );
        end
    endgenerate

    // 最後一級: 最高延遲 tap
    MX2X2 M1(
        .A(1'b0),               // 不使用時輸0（或1皆可，只要不用 d[8]）
        .B(d[TAPS-1]),          // 最大delay tap (最慢)
        .Y(sel[TAPS-1]),
        .S0(lambda[TAPS-1])
    );

    assign clk_out = sel[0];

endmodule
