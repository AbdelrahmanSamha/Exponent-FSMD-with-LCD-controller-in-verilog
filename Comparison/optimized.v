module optimized ( 
	  input clk, rst, go_i,
    input [7:0] n_i, a_i,
    output [15:0] output_reg,
    output sig_done);

wire [2:0] state;
    wire sel_a_reg, sel_n_reg, sel_result_reg;
    wire ld_a, ld_n, ld_result, ld_output;
    wire n_grtr_0;
    wire [7:0] n_reg;

    FSMcontrol_optimized control_unit (
        .clk(clk),
        .rst(rst),
        .go_i(go_i),
        .n_reg(n_reg),
        .n_grtr_0(n_grtr_0),
        .state(state),
        .sel_a_reg(sel_a_reg),
        .sel_n_reg(sel_n_reg),
        .sel_result_reg(sel_result_reg),
        .ld_a(ld_a),
        .ld_n(ld_n),
        .ld_result(ld_result),
        .ld_output(ld_output),
        .sig_done(sig_done)
    );

    datapath_optimized datapath_unit (
        .clk(clk),
        .rst(rst),
        .n_i(n_i),
        .a_i(a_i),
        .sel_a_reg(sel_a_reg),
        .sel_n_reg(sel_n_reg),
        .sel_result_reg(sel_result_reg),
        .ld_a(ld_a),
        .ld_n(ld_n),
        .ld_result(ld_result),
        .ld_output(ld_output),
        .output_reg(output_reg),
        .n_reg(n_reg),
        .n_grtr_0(n_grtr_0)
    );

endmodule 