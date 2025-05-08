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

    reg clk = 0;
    reg rst = 1;
    reg go_i = 0;
    reg [31:0] n_i = 32'd5;
    reg [31:0] a_i = 32'd3;

    wire [31:0] output_reg;
    wire sig_done;
    wire [7:0] LCD_DATA;
    wire LCD_EN, LCD_RS, LCD_RW;

    // Instantiate TL
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
        .LCD_RW(LCD_RW)
    );

    // 50MHz Clock
    always #10 clk = ~clk;

    initial begin
        $display("Starting TL testbench...");

        // Hold reset
        #50;
        rst = 0;

        // Trigger computation
        #50;
        go_i = 1; #20;
        go_i = 0;

        // Wait for LCD output
        wait (sig_done == 1);

        #2_000_000;  // Wait to simulate LCD activity
        $finish;
    end

endmodule

