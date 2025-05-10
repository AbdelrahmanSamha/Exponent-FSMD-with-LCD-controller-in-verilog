/*`timescale 1ns / 1ps

module tb;

    reg clk;
    reg rst;
    reg go_i;
    reg [31:0] a_i, n_i;

    wire [31:0] output_reg;
    wire sig_done;

    // Instantiate the TL module
    TL dut (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_i(n_i),
        .a_i(a_i),
        .output_reg(output_reg),
        .sig_done(sig_done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Starting simulation...");
        $monitor("Time=%0t | a_i=%0d, n_i=%0d, result=%0d, done=%b", $time, a_i, n_i, output_reg, sig_done);
        
        // Initialize signals
        clk = 0;
        rst = 1;
        go_i = 0;
        a_i = 0;
        n_i = 0;

        // Reset pulse
        #10;
        rst = 0;

        // Test 1: a = 3, n = 4 => result = 81
        a_i = 3;
        n_i = 4;
        go_i = 1;

        #10 go_i = 0;  // Deassert go after one clock

        // Wait for computation to complete
        wait (sig_done == 1);
        #10;

        if (output_reg == 81)
            $display("Test Passed: 3^4 = %d", output_reg);
        else
            $display("Test Failed: Expected 81, Got %d", output_reg);

        // Add more tests here if needed
        $finish;
    end

endmodule
*/

module tb;

    reg clk;
    reg rst;
    reg go_i;
    reg [7:0] a_i, n_i;

    wire [15:0] output_reg;
    wire sig_done;

    wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;

    // Instantiate the TL module
    TL dut (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_i(n_i),
        .a_i(a_i),
        .output_reg(output_reg),
        .sig_done(sig_done),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5),
        .seg6(seg6),
        .seg7(seg7)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Starting simulation...");
        $monitor("Time=%0t | a_i=%0d, n_i=%0d, result=%0d, done=%b", $time, a_i, n_i, output_reg, sig_done);

        // Initialize
        clk = 0;
        rst = 1;
        go_i = 0;
        a_i = 0;
        n_i = 0;

        // Reset pulse
        #10;
        rst = 0;

        // Test 1: a = 3, n = 4 → result = 81
        a_i = 3;
        n_i = 4;
        go_i = 1;
        #10 go_i = 0;

        wait (sig_done == 1);
        #10;

        if (output_reg == 81)
            $display("Test Passed: 3^4 = %d", output_reg);
        else
            $display("Test Failed: Expected 81, Got %d", output_reg);

        // Optional: Display segment values
        $display("7-Segment Outputs (HEX Display):");
        $display("seg0 = %b", seg0);
        $display("seg1 = %b", seg1);
        $display("seg2 = %b", seg2);
        $display("seg3 = %b", seg3);
        $display("seg4 = %b", seg4);
        $display("seg5 = %b", seg5);
        $display("seg6 = %b", seg6);
        $display("seg7 = %b", seg7);

        $finish;
    end

endmodule



