module shifter (
						input [15:0] a,
						input [2:0]shmat,
						output [15:0] out);
						
						
assign out = a>>shmat;  			
						
endmodule 