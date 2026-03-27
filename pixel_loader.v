`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2026 20:56:33
// Design Name: 
// Module Name: pixel_loader
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pixel_loader (
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid,

    output reg [7:0] avg,
    output reg [31:0] ahash,
    output reg done,
    output reg [7:0] edge1,
    output reg [63:0] signature,
    output reg [23:0] dhash
);

    reg [7:0] pixels [0:63];
    reg [15:0] sum;
    reg [5:0] count;
    reg [1:0] state;
    integer i;

    localparam LOAD = 0, CALC = 1, DONE = 2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dhash <= 0;
            sum <= 0;
            count <= 0;
            edge1 <= 0;
            avg <= 0;
            done <= 0;
            state <= LOAD;
        end else begin
            case (state)

                // ---------------- LOAD PIXELS ----------------
                LOAD: begin
                    if (valid) begin
                        pixels[count] <= pixel_in;
                        sum <= sum + {8'b0, pixel_in};
                        count <= count + 1;

                        if (count == 63) begin
				/* verilator lint_off WIDTHTRUNC */
                            avg <= (sum + {8'b0, pixel_in}) >> 6;
				/* verilator lint_on WIDTHTRUNC */
                            state <= CALC;
                        end
                    end
                end

                // ---------------- COMPUTE aHASH ----------------
                CALC: begin
                    for (i = 0; i < 32; i = i + 1) begin
                        if (((pixels[2*i] + pixels[2*i+1]) >> 1) >= avg)
                            ahash[i] <= 1;
                        else
                            ahash[i] <= 0;
                    end
                    // -------- dHash --------
                    for (i = 0; i < 24; i = i + 1) begin
                        if (pixels[i] > pixels[i+1])
                            dhash[i] <= 1;
                        else
                            dhash[i] <= 0;
                    end
                    // -------- Edge Feature --------
                    for (i = 0; i < 8; i = i + 1) begin
                        if (pixels[8*i+1] > pixels[8*i]) begin
                            if ((pixels[8*i+1] - pixels[8*i]) > 8)
                                edge1[i] <= 1;
                            else
                                edge1[i] <= 0;
                            end else begin
                        if ((pixels[8*i] - pixels[8*i+1]) > 8)
                            edge1[i] <= 1;
                        else
                            edge1[i] <= 0;
                        end
                    end
                   
                    state <= DONE;
                end
                          
            
                // ---------------- DONE ----------------
                DONE: begin
                    signature <= {ahash, dhash, edge1};
                    done <= 1;
                end

            endcase
        end
    end

endmodule

