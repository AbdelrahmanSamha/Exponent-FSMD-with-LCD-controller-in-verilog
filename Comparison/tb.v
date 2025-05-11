module tb;

    reg clk;
    reg rst;  // Active-low reset
    reg go_i;
    reg [7:0] a_i, n_i;

    wire [15:0] output_reg_normal;
    wire [15:0] output_reg_optimized;
    wire sig_done_normal;
    wire sig_done_optimized;

    // Instantiate TL
    TL dut (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .a_i(a_i),
        .n_i(n_i),
        .output_reg_normal(output_reg_normal),
        .output_reg_optimized(output_reg_optimized),
        .sig_done_normal(sig_done_normal),
        .sig_done_optimized(sig_done_optimized)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer t_start_normal, t_end_normal, t_start_opt, t_end_opt;

    task run_test;
        input [7:0] a_val;
        input [7:0] n_val;
        input [15:0] expected;
        begin
            $display("\n===============================");
            $display("Test: a = %0d, n = %0d (Expect %0d)", a_val, n_val, expected);
            $display("===============================\n");

            // Reset
            rst = 0; #20; rst = 1; #10;

            // Apply inputs
            a_i = a_val;
            n_i = n_val;
            go_i = 1; #10; go_i = 0;

            // Start time tracking
            t_start_normal = $time;
            wait(sig_done_normal);
            t_end_normal = $time;

            t_start_opt = $time;
            wait(sig_done_optimized);
            t_end_opt = $time;

            // Output results
            $display("Time=%0t | normal=%0d, optimized=%0d", $time, output_reg_normal, output_reg_optimized);
            $display("Done signals -> Normal: %b | Optimized: %b", sig_done_normal, sig_done_optimized);
            $display("Execution Time -> Normal: %0d cycles | Optimized: %0d cycles",
                     (t_end_normal - t_start_normal)/10,
                     (t_end_opt - t_start_opt)/10);

            if (output_reg_normal == output_reg_optimized && output_reg_normal == expected)
                $display("PASS ? Result = %0d\n", output_reg_normal);
            else begin
                $display("FAIL ? Mismatch or wrong result:");
                $display("  Normal    = %0d", output_reg_normal);
                $display("  Optimized = %0d", output_reg_optimized);
                $display("  Expected  = %0d\n", expected);
            end
        end
    endtask

    initial begin
        $display("=== Starting simulation ===");

        clk = 0;
        rst = 1;
        go_i = 0;
        a_i = 0;
        n_i = 0;

        // ----------- Test Cases -----------
        run_test(3, 4, 81);          // 3^4 = 81
	#10
        run_test(5, 5, 3125);        // 5^5 = 3125
	#10
        run_test(2, 15, 32768);      // 2^16 = 65536 ? clamp
	#10
        run_test(9, 4, 6561);        // 9^4 = 6561
	#10
        run_test(7, 5, 16807);       // 7^5 = 16807
	#10
        run_test(2, 14, 16384);      // 2^14 = 16384
	#10
        run_test(11, 4, 14641);      // 11^4 = 14641
	#10
        run_test(13, 3, 2197);       // 13^3 = 2197

        $display("\n=== All tests completed at time %0t ===", $time);
        $finish;
    end

endmodule

