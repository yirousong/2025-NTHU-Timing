module Controller (
    input            lead_lag,
    input            clk,
    input            rst_n,
    output reg [7:0] lambda
);

    reg        [2:0] alpha_next;
    reg        [2:0] alpha;
    reg        [2:0] count;

    // count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd1;
        else
            count <= count + 3'd1;
    end

    // alpha
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alpha <= 3'd7;
        else
            alpha <= alpha_next;
    end

    always @(*) begin
        alpha_next = alpha;
        if (lead_lag && count == 7) begin
            if (alpha == 3'd7)
                alpha_next = 3'd7;
            else
                alpha_next = alpha + 3'd1;
        end
        else if (!lead_lag && count == 7) begin
            if (alpha == 3'd0)
                alpha_next = 3'd0;
            else
                alpha_next = alpha - 3'd1;
        end
    end
    

    // decoder
    always @(*) begin
        lambda = 8'd128;
        case (alpha)
            3'd0 : lambda = 8'd1;
            3'd1 : lambda = 8'd2;
            3'd2 : lambda = 8'd4;
            3'd3 : lambda = 8'd8;
            3'd4 : lambda = 8'd16;
            3'd5 : lambda = 8'd32;
            3'd6 : lambda = 8'd64;
            3'd7 : lambda = 8'd128;
            default : lambda = 8'd1;
        endcase
    end

endmodule