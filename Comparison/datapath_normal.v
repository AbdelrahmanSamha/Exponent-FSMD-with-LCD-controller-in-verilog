module datapath_normal(
  input clk, rst,
    input [7:0] n_i, a_i,
    input  sel_n_reg, sel_result_reg,
    input ld_a, ld_n, ld_result, ld_output,
    output reg [15:0] output_reg,
    output n_grtr_0
);

reg [15:0] a_reg, result_reg;
reg [7:0] n_internal;

wire [7:0] sub_out;
wire [15:0] outmuxresult, outmuxn;
wire [15:0] outproductres;

assign n_reg = n_internal;


always @(posedge clk, negedge rst) begin
    if (~rst) begin
        n_internal <= 8'b0;
        a_reg <= 16'b0;
        result_reg <= 16'b0;
		  output_reg <=16'b0;
    end else begin
        if (ld_a)      a_reg <= a_i ;
        if (ld_n)      n_internal <= outmuxn[7:0];
        if (ld_result) result_reg <= outmuxresult;
		  if (ld_output) output_reg <= result_reg;
    end
end








mult multiRES   (.a(result_reg),  .b(a_reg), .product(outproductres));
mux2to1 muxn    (.a({8'b0,n_i}), .b({8'b0,sub_out}), .sel(sel_n_reg),    .out(outmuxn));
mux2to1 muxres  (.a(16'b1), .b(outproductres), .sel(sel_result_reg), .out(outmuxresult));
subtractor sub (.in(n_internal),.out(sub_out));
comparator cmp  (.N(n_internal),  .n_grtr_0(n_grtr_0));

endmodule