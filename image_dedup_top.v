`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2026 21:32:57
// Design Name: 
// Module Name: image_dedup_top
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

module image_dedup_top (
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid,

    input [63:0] ref_sig,
    input [6:0] threshold,

    output [63:0] signature,
    output duplicate,
    output done
);

    wire [31:0] ahash;
    wire [23:0] dhash;
    wire [7:0] edge1;
    wire [7:0] avg;

    wire [6:0] distance;

    // ---------------- SIGNATURE GENERATOR ----------------
    pixel_loader u1 (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .valid(valid),
        .avg(avg),
        .ahash(ahash),
        .dhash(dhash),
        .edge1(edge1),
        .signature(signature),
        .done(done)
    );

    // ---------------- COMPARATOR ----------------
    duplicate_detector u2 (
        .sig1(signature),
        .sig2(ref_sig),
        .threshold(threshold),
        .duplicate(duplicate),
        .distance(distance)
    );

endmodule