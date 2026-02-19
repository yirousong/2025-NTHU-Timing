module Controller (
    input            clk,
    input            rst_n,
    input            lead_lag,
    output reg [7:0] lambda,
    output reg       lock
);
    reg        [2:0] alpha_next;
    reg        [2:0] alpha;
    reg        [3:0] count;
    reg              lock_next;
    reg              lead_lag_last;

    // count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'd1;
        else
            count <= count + 4'd1;
    end
    
    // lead_lag_last
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lead_lag_last <= 1'd0;
        else if (count == 4'd0)
            lead_lag_last <= lead_lag;
    end

    // lock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lock <= 1'd0;
        else
            lock <= lock_next;
    end

    // alpha
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alpha <= 3'd7;
        else
            alpha <= alpha_next;
    end

    // next logic
    always @(*) begin
        lock_next = lock;
        alpha_next = alpha;
        if (count == 4'd15) begin
            if (lead_lag != lead_lag_last)
                lock_next = 1'b1;
            if (lead_lag) begin
                if (alpha == 3'd7)
                    alpha_next = 3'd7;
                else
                    alpha_next = alpha + 3'd1;
            end
            else if (!lead_lag) begin
                if (alpha == 3'd0)
                    alpha_next = 3'd0;
                else
                    alpha_next = alpha - 3'd1;
            end
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