`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2026 21:21:22
// Design Name: 
// Module Name: duplicate_detector
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

module duplicate_detector (
    input [63:0] sig1,
    input [63:0] sig2,
    input [6:0] threshold,
    output reg duplicate,
    output reg [6:0] distance
);

    integer i;
    reg [63:0] diff;

    always @(*) begin
        diff = sig1 ^ sig2;
        distance = 0;

        for (i = 0; i < 64; i = i + 1) begin
            distance = distance + (diff[i] ? 7'd1 : 7'd0);
        end

        if (distance <= threshold)
            duplicate = 1;
        else
            duplicate = 0;
    end

endmodule

