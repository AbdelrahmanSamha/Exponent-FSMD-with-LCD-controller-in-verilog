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
    output LCD_EN, LCD_RW, LCD_RS, LCD_ON, LCD_BLON, LCD_OVER,
	 output [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7
    
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

// Display Mapping: a_i[3:0], a_i[7:4], n_i[3:0], n_i[7:4], output_reg[3:0] to [15:12]
    hex_to_7seg_anode disp0 (.hex(a_i[3:0]),        .seg(seg0));
    hex_to_7seg_anode disp1 (.hex(a_i[7:4]),        .seg(seg1));
    hex_to_7seg_anode disp2 (.hex(n_i[3:0]),        .seg(seg2));
    hex_to_7seg_anode disp3 (.hex(n_i[7:4]),        .seg(seg3));
    hex_to_7seg_anode disp4 (.hex(output_reg[3:0]),   .seg(seg4));
    hex_to_7seg_anode disp5 (.hex(output_reg[7:4]),   .seg(seg5));
    hex_to_7seg_anode disp6 (.hex(output_reg[11:8]),  .seg(seg6));
    hex_to_7seg_anode disp7 (.hex(output_reg[15:12]), .seg(seg7));
	 
	 endmodule 

