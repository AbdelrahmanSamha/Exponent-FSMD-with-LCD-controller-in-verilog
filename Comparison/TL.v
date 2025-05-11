module TL (
    input clk, rst, go_i,
    input [7:0] n_i, a_i,
    output [15:0] output_reg_normal,
    output [15:0] output_reg_optimized,
    output sig_done_normal,
    output sig_done_optimized
);

    // Instantiate the Normal module
    Normal normal_unit (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_i(n_i),
        .a_i(a_i),
        .output_reg(output_reg_normal),
        .sig_done(sig_done_normal)
    );

    // Instantiate the Optimized module
    optimized optimized_unit (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_i(n_i),
        .a_i(a_i),
        .output_reg(output_reg_optimized),
        .sig_done(sig_done_optimized)
    );

endmodule
