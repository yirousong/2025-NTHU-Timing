`timescale	10ns/100ps
//`include "traffic_light_syn.v"
//`include "tsmc13.v"

module tb();

    parameter period = 2;
    parameter delay = 1;

    reg clk;
    reg reset;
    reg [9:0] target_y;

    wire [3:0] closet_x;
    wire done;


    hw1 UUT(clk, reset, target_y, closet_x, done);

    initial begin
        $fsdbDumpfile("../4.Simulation_Result/gcd_rtl.fsdb");
        $fsdbDumpvars;
    end

    always #(period / 2) clk = ~clk;

    initial begin
        clk = 1;
        reset = 1;
        target_y = 630;
        #(period + delay) reset = 0;
        #(period * 2) reset = 1;
        target_y = 780;

        @(negedge done);
        @(posedge clk);
        target_y = 630;

        @(negedge done);
        @(posedge clk);
        #(delay * 3) reset = 0;
        #(period * 8) $finish;
    end

    // Automatically finish
    initial begin
        #200;
        $finish;
    end


endmodule
