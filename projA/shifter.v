module shifter (
						input [31:0] a,
						input [4:0]shmat,
						output [31:0] out);
						
						
assign out = a>>shmat;  			
						
endmodule 