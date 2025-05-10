/*module TL (
    input clk, rst, go_i,
    input [5:0] n_i, a_i,
    output [5:0] output_reg,
    output sig_done
);

wire [2:0] state;
wire sel_a_reg, sel_n_reg, sel_result_reg;
wire ld_a, ld_n, ld_result,ld_output;
wire n_grtr_0;
wire [5:0] n_reg;

FSMcontrol control_unit (
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

datapath datapath_unit (
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
*/


module TL (
    input clk, rst, go_i,
    input [7:0] n_i, a_i,
    output [15:0] output_reg,
    output sig_done,

    // LCD interface
    output [7:0] LCD_DATA,
    output LCD_EN, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, LCD_OVER
    
);

    wire [2:0] state;
    wire sel_a_reg, sel_n_reg, sel_result_reg;
    wire ld_a, ld_n, ld_result, ld_output;
    wire n_grtr_0;
    wire [7:0] n_reg;

    FSMcontrol control_unit (
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

    datapath datapath_unit (
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

    // LCD display controller instance
    abd_lcd_initializer lcd_unit (
        .clk(clk),
        .rst(rst),
        .start(sig_done),         // Start display when done signal is high
        .a_in(a_i),
        .n_in(n_i),
        .res_in(output_reg),
        .LCD_DATA(LCD_DATA),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
		  .LCD_ON(LCD_ON),
		  .LCD_BLON(LCD_BLON),
		  .done(LCD_OVER)
    );

endmodule 

