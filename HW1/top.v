`timescale	10ns/100ps

module top(clk, reset, target_y, closet_x, done);

input clk;
input reset;
input [9:0] target_y;

output reg [3:0] closet_x;
output reg done;

reg [1:0] state;
reg [3:0] count;
wire [7:0] thirty_x;
wire [9:0] predict_y

parameter START = 2'b00;
parameter UPPER = 2'b01;
parameter LOWER = 2'b10;
parameter DONE  = 2'b11;

assign thirty_x = closet_x * 30
assign predict_y = 1000 - thirty_x

always @(*)
begin
    case(state)
        START:
        begin
            closet_x = 4'b1000;
            done = 1'b0;
        end
        UPPER:
        begin
            closet_x = closet_x | count;
            done = 1'b0;
        end
        LOWER:
        begin
            closet_x = closet_x >> 1;
            done = 1'b0;
        end
        DONE:
        begin
            done = 1'b1;
        end
    endcase
end

always @(posedge clk)
begin
    if(~reset)
    begin
        count = 4'b1000;
        state = START;
    end
    else
    begin
        count = count >> 1;
    end

    case (state)
        START:
            begin
                if(predict_y > target_y)
                    state = UPPER;
                else
                    state = LOWER;
            end
        UPPER:
            if (count  == 1)
            begin
                state = DONE;
            end
            else if(predict_y > target_y)
            begin
                state = UPPER;
            end
            else
            begin
                state = LOWER;
            end
        LOWER:
            if (count  == 1)
            begin
                state = DONE;
            end
            else if(predict_y > target_y)
            begin
                state = UPPER;
            end
            else
            begin
                state = LOWER;
            end
        DONE:
            state = START;
    endcase
end
endmodule
