module comparator (
	input [31:0] N ,
	output n_grtr_0


);


assign n_grtr_0 = (N >0)? 1'b1:1'b0;


endmodule
