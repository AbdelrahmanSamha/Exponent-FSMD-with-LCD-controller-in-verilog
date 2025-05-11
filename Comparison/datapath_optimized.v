module datapath_optimized(
    input clk, rst,
    input [7:0] n_i, a_i,
    input sel_a_reg, sel_n_reg, sel_result_reg,
    input ld_a, ld_n, ld_result, ld_output,
    output reg [15:0] output_reg,
    output [7:0] n_reg,
    output n_grtr_0
);

reg [15:0] a_reg;
reg [15:0] result_reg;
reg [7:0] n_internal;

wire [15:0] outmuxa, outmuxn, outmuxresult;
wire [15:0] outproducta, outproductres;
wire [15:0] shifter_out;

assign n_reg = n_internal;

always @(posedge clk, negedge rst) begin
    if (~rst) begin
        n_internal <= 8'b0;
        a_reg <= 16'b0;
        result_reg <= 16'b0;
		  output_reg <=16'b0;
    end else begin
        if (ld_a)      a_reg <= outmuxa;
        if (ld_n)      n_internal <= outmuxn[7:0];
        if (ld_result) result_reg <= outmuxresult;
		  if (ld_output) output_reg <= result_reg;
    end
end

mux2to1 muxa    (.a({8'b0,a_i}), .b(outproducta), .sel(sel_a_reg),    .out(outmuxa));
mux2to1 muxn    (.a({8'b0,n_i}), .b(shifter_out), .sel(sel_n_reg),    .out(outmuxn));
mux2to1 muxres  (.a(16'b1), .b(outproductres), .sel(sel_result_reg), .out(outmuxresult));

mult multiA     (.a(a_reg),       .b(a_reg),        .product(outproducta));
mult multiRES   (.a(result_reg),  .b(a_reg),        .product(outproductres));
shifter shifter (.a({8'b0,n_internal}),  .shmat(3'b1),     .out(shifter_out));
comparator cmp  (.N(n_internal),  .n_grtr_0(n_grtr_0));

endmodule