`timescale 1ns/100ps
module PLL_tb();

    parameter period = 10;
    reg clk_ref;
    reg rst_n;
    reg [3:0] N;
    reg enable;
    wire clk_DCO;
    wire lock;
    wire clk_div;
    wire lead_lag;
    // wire [1:0] alpha;
    wire [7:0] lambda;

    PLL UUT(.clk_ref(clk_ref),
            .rst_n(rst_n),
            .N(N),
            .enable(enable),
            .clk_DCO(clk_DCO),
            .lock(lock)
            .clk_div(clk_div)
            .lead_lag(lead_lag)
            .alpha(alpha)
            .lambda(lambda));

    always #(period/2) clk_ref = ~clk_ref;

    initial begin
      clk_ref= 1;
      N      = 10;
      enable = 0;
      rst_n  = 1;
      #(period)
      rst_n  = 0;
      #(period * 10)
      rst_n  = 1;
      #(period * 5)
      enable = 1;
      #1000000
      $finish;
    end

    initial begin
        $sdf_annotate("./PLL_syn.sdf", UUT);
        $fsdbDumpfile("../4.Simulation_Result/PLL_syn.fsdb");
        $fsdbDumpvars;
    end
endmodule