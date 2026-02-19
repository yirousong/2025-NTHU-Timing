`timescale 100ps/1ps
module PLL_tb();

    parameter period = 100;

    reg        clk_ref;
    reg        rst_n;
    reg        enable;
    reg  [3:0] N;

    wire       clk_out;
    // wire       clk_div;
    wire       lead_lag;
    wire [7:0] lambda;

    PLL UUT (
            .clk_ref(clk_ref),
            .rst_n(rst_n),
            .N(N),
            .enable(enable),
            .clk_out(clk_out),
            // .clk_div(clk_div),
            .lead_lag(lead_lag),
            .lambda(lambda)
            );

    always #(period/2) clk_ref = ~clk_ref;

    initial begin
      clk_ref  = 0; rst_n  = 1; N = 10; enable = 0;
      #(period * 2) rst_n  = 0;
      #(period * 2) rst_n  = 1;
      #(period * 2) enable = 1;
      #100000
      $finish;
    end

    initial begin
        $sdf_annotate("./PLL_syn.sdf", UUT);
        $fsdbDumpfile("../4.Simulation_Result/PLL_syn.fsdb");
        $fsdbDumpvars;
    end
endmodule
