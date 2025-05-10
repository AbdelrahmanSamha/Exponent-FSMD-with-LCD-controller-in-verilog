module FSMcontrol (
    input clk, rst, go_i,
    input [7:0] n_reg,
    input n_grtr_0,
    output reg [2:0] state,
    output reg sel_a_reg, sel_n_reg, sel_result_reg,
    output ld_a, ld_n, ld_result,
	 output reg ld_output,
    output reg sig_done
);

parameter idle = 3'b000, init= 3'b001, check = 3'b010,
          process_even = 3'b011, process_odd = 3'b100, done = 3'b101;

always @(posedge clk, posedge rst) begin 
    if (rst) begin 
		state <= idle;
		sig_done <=1'b0;
	 end
    else begin
        case (state)
            idle:         state <= (go_i) ? init : idle;
            init:         state <= check;
            check: begin
                if (!n_grtr_0) state <= done;
                else if (!n_reg[0]) state <= process_even;
                else state <= process_odd;
            end
            process_odd:  state <= check;
            process_even: state <= check;
            done: begin 
				state <= idle;
				sig_done <= 1'b1;
				end 
            default:      state <= idle;
        endcase
    end
end

always @(*) begin
    // Default values
    sel_a_reg = 0;
    sel_result_reg = 0;
    sel_n_reg = 0;
    ld_output = 0;

    case (state)
        init: begin
            sel_a_reg = 0;
            sel_result_reg = 0;
            sel_n_reg = 0;
        end
        process_odd: begin
            sel_a_reg = 1;
            sel_result_reg = 1;
            sel_n_reg = 1;
        end
        process_even: begin
            sel_a_reg = 1;
            sel_n_reg = 1;
        end
        done: ld_output = 1;
    endcase
end

assign ld_a = (state == process_even || state == process_odd || state == init);
assign ld_n = ld_a;
assign ld_result = (state == process_odd || state == init);

endmodule