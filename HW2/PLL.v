`include "../2.Gate_level_simulation/PD_syn.v"
`include "../2.Gate_level_simulation/DCO_syn.v"
`include "../2.Gate_level_simulation/frequency_divider_syn.v"
`include "Controller.v"

module PLL (
    input         clk_ref,
    input         rst_n,
    input         enable,
    input  [3:0]  N,
    output        clk_out,
    output        lead_lag,
    output [7:0]  lambda
);

    wire          clk_div;

    Controller Controller (
        .lead_lag (lead_lag),
        .clk      (clk_ref),
        .rst_n    (rst_n),
        .lambda   (lambda)
    );

    PD PD (
        .clk_in   (clk_ref),
        .FB       (clk_div),
        .enable   (rst_n),
        .lead_lag (lead_lag)
    );

    DCO DCO (
        .enable   (enable),
        .lambda   (lambda),
        .dco_clk  (clk_out)
    );

    frequency_divider frequency_divider (
        .fin      (clk_out),
        .N        (N),
        .rst_n    (rst_n),
        .fout     (clk_div)
    );

endmodule