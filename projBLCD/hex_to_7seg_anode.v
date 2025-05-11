module hex_to_7seg_anode (
    input  [3:0] hex,     // 4-bit hex input
    output [6:0] seg      // seg[6:0] = {g, f, e, d, c, b, a}
);
    reg [6:0] seg_out;

    always @(*) begin
        case (hex)
            4'h0: seg_out = 7'b1000000; // a b c d e f
            4'h1: seg_out = 7'b1111001; // b c
            4'h2: seg_out = 7'b0100100; // a b d e g
            4'h3: seg_out = 7'b0110000; // a b c d g
            4'h4: seg_out = 7'b0011001; // b c f g
            4'h5: seg_out = 7'b0010010; // a c d f g
            4'h6: seg_out = 7'b0000010; // a c d e f g
            4'h7: seg_out = 7'b1111000; // a b c
            4'h8: seg_out = 7'b0000000; // a b c d e f g
            4'h9: seg_out = 7'b0010000; // a b c d f g
            4'hA: seg_out = 7'b0001000; // a b c e f g
            4'hB: seg_out = 7'b0000011; // c d e f g
            4'hC: seg_out = 7'b1000110; // a d e f
            4'hD: seg_out = 7'b0100001; // b c d e g
            4'hE: seg_out = 7'b0000110; // a d e f g
            4'hF: seg_out = 7'b0001110; // a e f g
            default: seg_out = 7'b1111111; // all off
        endcase
    end

    assign seg = seg_out; // Active-low for common-anode
endmodule
