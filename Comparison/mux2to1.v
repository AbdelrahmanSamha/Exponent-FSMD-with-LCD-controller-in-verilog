module mux2to1(

		input [15:0] a, b ,
		input sel,
		output [15:0] out
		);

assign out = (!sel)? a:b;


endmodule