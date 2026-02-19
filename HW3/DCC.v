`include "../2.Gate_level_simulation/PD_syn.v"
`include "../2.Gate_level_simulation/TDL_syn.v"
`include "Controller.v"
`include "../2.Gate_level_simulation/SRLatch_syn.v"
`include "../2.Gate_level_simulation/OneShot_syn.v"

module DCC (
    input         clk_in,
    input         rst_n,
    output        clk_dcc,
    output [7:0]  lambda,
    output        lock
);
    wire clk_os;
    wire lead_lag;
    wire clk_hp;
    wire clk_dll;

    OneShot OneShot (
        .din       (clk_in),
        .dout      (clk_os)
    );

    PD PD (
        .clk_in    (clk_os),
        .FB        (clk_dll),
        .enable    (rst_n),
        .lead_lag  (lead_lag)
    );

    Controller Controller (
        .lead_lag  (lead_lag),
        .clk       (clk_in),
        .rst_n     (rst_n),
        .lambda    (lambda),
        .lock      (lock)
    );

    TDL TDL1 (
        .clk_in    (clk_os),
        .lambda    (lambda),
        .clk_out   (clk_hp)
    );

    TDL TDL2 (
        .clk_in    (clk_hp),
        .lambda    (lambda),
        .clk_out   (clk_dll)
    );

    SRLatch SRLatch(
        .S         (clk_os),
        .R         (clk_hp),
        .Q         (clk_dcc)
    );

endmodule

