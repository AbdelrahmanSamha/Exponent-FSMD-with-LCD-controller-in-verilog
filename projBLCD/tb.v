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

`timescale 1ns/1ps

module tb;

    // Inputs
    reg clk = 0;
    reg rst = 0;
    reg go_i = 0;
    reg [7:0] n_i = 8'd8;
    reg [7:0] a_i = 8'd2;

    // Outputs
    wire [15:0] output_reg;
    wire sig_done;
    wire [7:0] LCD_DATA;
    wire LCD_EN, LCD_RS, LCD_RW;
    wire LCD_ON, LCD_BLON, LCD_OVER;

    // Instantiate TL module
    TL uut (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_i(n_i),
        .a_i(a_i),
        .output_reg(output_reg),
        .sig_done(sig_done),
        .LCD_DATA(LCD_DATA),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .LCD_OVER(LCD_OVER)
    );

    // Clock generation: 50MHz (20ns period)
    always #10 clk = ~clk;

    initial begin
        $display("----- Starting TL Testbench -----");

        // Hold reset
        #50;
        rst = 1;

        // Trigger computation
        #100;
        go_i = 1;
        #20;
        go_i = 0;

        // Wait for result ready
        wait (sig_done == 1);
        $display("Computation done. Output result: %d", output_reg);

        // Wait for LCD to finish displaying
        wait (LCD_OVER == 1);
        $display("LCD finished displaying.");

        // Let waveform capture stabilize
        #1_000_000;

        $finish;
    end

endmodule


