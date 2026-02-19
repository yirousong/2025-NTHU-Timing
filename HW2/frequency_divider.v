module frequency_divider (
    input        fin,          
    input        rst_n,        
    input  [3:0] N, 
    output reg   fout
);

    reg    [3:0] count;

    // Half N
    wire   [3:0] N_h = {1'b0, N[3:1]};

    // count
    always @(posedge fin or negedge rst_n) begin
        if (!rst_n)
            count <= 4'd1;
        else
            count <= (count >= N)? 4'd1 : count  + 4'd1;
    end

    // fout
    always @(posedge fin or negedge rst_n) begin
        if (!rst_n)
            fout <= 1'b0;
        else
            fout <= (count <= N_h)? 1'b1 : 1'b0;
    end

endmodule

// module frequency_divider(
//     input fin,
//     input [3:0] N,
//     input rst_n,
//     output reg fout
// );
//     reg [3:0] counter;

//     always @(posedge fin or negedge rst_n ) begin
//         if(!rst_n)begin
//             counter<=4'd0;
//             fout<=1'd0;
//         end
//         else if(counter==((N>>1)-1))begin
//             counter<=4'd0;
//             fout<=~fout;
//         end
//         else begin
//             counter<=counter+4'd1;
//             fout<=fout;
//         end
//     end

// endmodule