`timescale 100ps/1ps
module DCC_tb();

    parameter period = 10;
    parameter delay = 1;
	parameter real DUTY = 0.3; // 0.3 = 30%


    reg        clk_in;
    reg        rst_n;

    wire       clk_dcc;
    wire [7:0] lambda;
    wire       lock;


	initial begin
		clk_in = 0;
		forever begin
			clk_in = 1; #(period * DUTY);
			clk_in = 0; #(period * (1.0 - DUTY));
		end
	end


    DCC UUT (
            .clk_in(clk_in),
            .rst_n(rst_n),
            .clk_dcc(clk_dcc),
            .lambda(lambda),
            .lock(lock)
            );

    initial begin
                                    rst_n  = 1;
        #(period * 1)               rst_n  = 0;
        #(period * 2 + delay * 2)   rst_n  = 1;
        #(period * 200)
        $finish;
    end

    // Duty cycle measurement block
    real t_rise, t_fall, t_next_rise;
    real high_time, period_time, duty_cycle, duty_cycle_n;

    integer cycle_cnt = 0;

    initial begin
        // 等待第一個上升沿
        @(posedge clk_dcc);
        t_rise = $realtime;
        $display(" --------------------------- Simulation Start ----------------------------");
        $display("                           clk_in  [Duty Cycle] = %.1f %%", DUTY*100);
        $display(" -------------------------------------------------------------------------");
        forever begin
            // 等待下降沿 → 記錄 high time
            @(negedge clk_dcc);
            t_fall = $realtime;

            // 等待下一個上升沿 → 記錄 period
            @(posedge clk_dcc);
            t_next_rise = $realtime;

            high_time   = t_fall - t_rise;
            period_time = (t_next_rise - t_rise);
            duty_cycle  = (high_time / period_time) * 100.0;
            cycle_cnt = cycle_cnt + 1;

            // 每 4 個 cycle 印一次
            if (cycle_cnt == 15) begin
                $display(" lambda = %d (decimal)    clk_dcc [Duty Cycle] = %.1f %%     period = %0d ns",
                        UUT.lambda, duty_cycle, period_time * 0.1); // 因為 timescale=100ps → 1ns=10
                cycle_cnt = 0; // reset counter
            end

            // 下一輪量測
            t_rise = t_next_rise;
        end
    end



    initial begin
        $sdf_annotate("./DCC_syn.sdf", UUT);
        $fsdbDumpfile("../4.Simulation_Result/DCC_syn.fsdb");
        $fsdbDumpvars;
    end
endmodule