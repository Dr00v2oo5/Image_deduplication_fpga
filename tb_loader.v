`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2026 20:57:40
// Design Name: 
// Module Name: tb_loader
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


module tb_loader;

`ifdef VERILATOR
    initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_loader);
    end

`endif

 // Clock
    reg clk = 0;
    always #5 clk <= ~clk;

    // Inputs
    reg rst;
    reg [7:0] pixel;
    reg valid;

    reg [63:0] ref_sig;
    reg [6:0] threshold;

    // Outputs
    wire [63:0] signature;
    wire duplicate;
    wire done;

    //image mem
    reg [7:0] image_mem [0:63];  // for 8x8 image (64 pixels)

    // DUT (Top Module)
    image_dedup_top uut (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel),
        .valid(valid),
        .ref_sig(ref_sig),
        .threshold(threshold),
        .signature(signature),
        .duplicate(duplicate),
        .done(done)
    );

    integer i;

    initial begin
    $readmemh("pika.hex", image_mem);
    end

    initial begin
        // ---------------- RESET ----------------
        rst = 1;
        valid = 0;
        pixel = 0;
        ref_sig = 0;
        threshold = 5;

        #10 rst = 0;

    // ---------------- FEED IMAGE ----------------
    for (i = 0; i < 64; i = i + 1) begin
        pixel = image_mem[i];   // <-- real image data
        valid = 1;
        #10;
    end

    valid = 0;
        // ---------------- WAIT FOR SIGNATURE ----------------
        wait(done);
        #10;

        $display("Generated Signature = %h", signature);

        // ---------------- TEST CASE 1: SAME IMAGE ----------------
        ref_sig = signature;
        threshold = 5;
        #10;

        $display("\n--- CASE 1: SAME IMAGE ---");
        $display("Distance should be 0");
        $display("Duplicate = %b", duplicate);

        // ---------------- TEST CASE 2: SLIGHT CHANGE ----------------
        ref_sig =  64'h0000000044000060;   // flip 1 bit
        threshold = 0;
        #10;

        $display("\n--- CASE 2: SLIGHT CHANGE ---");
        $display("--- COPY OF THE PIKACHU WITHOUT EARS ---");
        $display("Duplicate = %b", duplicate);

        // ---------------- TEST CASE 3: DIFFERENT IMAGE ----------------
        ref_sig = 64'h0000000000000000;
        #10;

        $display("\n--- CASE 3: DIFFERENT IMAGE ---");
        $display("Distance should be large (~16)");
        $display("Duplicate = %b", duplicate);

        // ---------------- END ----------------
        #20;
        $finish;
    end

endmodule
