module FSMcontrol_normal(
    input clk, rst, go_i,
    input n_grtr_0,
    output reg [2:0] state,
    output sel_n_reg, sel_result_reg,
    output ld_a, ld_n, ld_result,
	 output  ld_output,
    output reg sig_done);
	 
parameter idle = 3'b000, init= 3'b001, check = 3'b010,
          process = 3'b011, done = 3'b100;
			 
always @(posedge clk, negedge rst) begin 
    if (~rst) begin 
		state <= idle;
		sig_done <=1'b0;
	 end
    else begin
        case (state)
            idle:         state <= (go_i) ? init : idle;
            init:         state <= check;
            check: begin
                if (!n_grtr_0) state <= done;
                else  state <= process;
              
            end
            process:  state <= check;
            done: begin 
				state <= idle;
				sig_done <= 1'b1;
				end 
            default:      state <= idle;
        endcase
    end
end
 
assign ld_a = (state==init);
assign ld_n = (state == process || state == init);
assign ld_result = (state == process || state == init);

assign sel_n_reg = (state==process);
assign sel_result_reg = (state==process);


assign ld_output = (state==done);




endmodule