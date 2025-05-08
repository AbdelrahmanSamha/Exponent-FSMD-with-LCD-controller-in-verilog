module datapath(
    input clk, rst,
    input [5:0] n_i, a_i,
    input sel_a_reg, sel_n_reg, sel_result_reg,
    input ld_a, ld_n, ld_result, ld_output,
    output reg [5:0] output_reg,
    output [5:0] n_reg,
    output n_grtr_0
);

reg [5:0] a_reg, result_reg;
reg [5:0] n_internal;

wire [5:0] outmuxa, outmuxn, outmuxresult;
wire [5:0] outproducta, outproductres;
wire [5:0] shifter_out;

assign n_reg = n_internal;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        n_internal <= 5'b0;
        a_reg <= 5'b0;
        result_reg <= 5'b0;
		  output_reg <=5'b0;
    end else begin
        if (ld_a)      a_reg <= outmuxa;
        if (ld_n)      n_internal <= outmuxn;
        if (ld_result) result_reg <= outmuxresult;
		  if (ld_output) output_reg <= result_reg;
    end
end

mux2to1 muxa    (.a(a_i), .b(outproducta), .sel(sel_a_reg),    .out(outmuxa));
mux2to1 muxn    (.a(n_i), .b(shifter_out), .sel(sel_n_reg),    .out(outmuxn));
mux2to1 muxres  (.a(5'b1), .b(outproductres), .sel(sel_result_reg), .out(outmuxresult));

mult multiA     (.a(a_reg),       .b(a_reg),        .product(outproducta));
mult multiRES   (.a(result_reg),  .b(a_reg),        .product(outproductres));
shifter shifter (.a(n_internal),  .shmat(5'b1),     .out(shifter_out));
comparator cmp  (.N(n_internal),  .n_grtr_0(n_grtr_0));

endmodule