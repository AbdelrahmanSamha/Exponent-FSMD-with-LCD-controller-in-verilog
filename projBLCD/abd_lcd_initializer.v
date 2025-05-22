


module abd_lcd_initializer (
    input clk,
    input rst,
    input start,
    input [7:0] a_in, n_in,
    input [15:0] res_in,
    output reg [7:0] LCD_DATA,
    output reg LCD_EN,
    output reg LCD_RS,
    output reg LCD_RW,
    output reg LCD_ON,
    output reg LCD_BLON,
    output reg done
);

// Timing constants
localparam DELAY_15MS = 32'd750_000; // 15ms
localparam DELAY_5MS  = 32'd250_000; // 5ms
localparam EN_PULSE   = 32'd50;      // ~1000ns
localparam RS_SETUP   = 32'd2;       // 2 cycles for ~40ns setup time

// FSM states
localparam 
    IDLE         = 6'd0,
    WAIT_15      = 6'd1,
    CMD_0        = 6'd2,
    CMD_1        = 6'd3,
    CMD_2        = 6'd4,
    CMD_3        = 6'd5,
    CMD_4        = 6'd6,
    CMD_5        = 6'd7,
    CMD_6        = 6'd8,
    CMD_7        = 6'd9,
    CMD_8        = 6'd10,
    CMD_9        = 6'd11,
    RS_WAIT      = 6'd12,
    EN_HIGH      = 6'd13,
    EN_LOW       = 6'd14,
    DELAY_5      = 6'd15,
    SEND_CHAR    = 6'd16,
    CHAR_RS_WAIT = 6'd17,
    CHAR_EN_HIGH = 6'd18,
    CHAR_EN_LOW  = 6'd19,
    DONE         = 6'd20;

reg [5:0] state;
reg [3:0] cmd_index;
reg [31:0] counter;
reg [4:0] char_index;
reg init;

reg [7:0] command_seq [0:9];

function [7:0] nibble_to_ascii;
    input [3:0] nibble;
    begin
        if (nibble < 10)
            nibble_to_ascii = "0" + nibble;
        else
            nibble_to_ascii = "A" + (nibble - 10);
    end
endfunction

always @ (posedge clk, negedge rst) begin
    if (~rst) begin
        state <= IDLE;
        counter <= 1'b0;
        cmd_index <= 4'b0;
        char_index <= 5'b0;
        LCD_BLON <= 1'b1;
        LCD_ON <= 1'b1;
        LCD_DATA <= 8'd0;
        {LCD_EN, LCD_RS, LCD_RW} <= 3'b000;
        done <= 1'b0;
        init <= 1'b0;
        command_seq[0] = 8'h30;
        command_seq[1] = 8'h30;
        command_seq[2] = 8'h30;
        command_seq[3] = 8'h3C;
        command_seq[4] = 8'h08;
        command_seq[5] = 8'h01;
        command_seq[6] = 8'h06;
        command_seq[7] = 8'h0E;
        command_seq[8] = 8'h01;
        command_seq[9] = 8'h80;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= WAIT_15;
                    counter <= 0;
                    done <= 0;
                end
            end

            WAIT_15: begin
                if (counter >= DELAY_15MS) begin
                    state <= CMD_0;
                    init <= 1;
                    counter <= 0;
                    cmd_index <= 0;
                end else counter <= counter + 1;
            end

            CMD_0, CMD_1, CMD_2, CMD_3, CMD_4, CMD_5, CMD_6, CMD_7, CMD_8, CMD_9: begin
                LCD_RS <= 0;
                LCD_RW <= 0;
                LCD_DATA <= command_seq[cmd_index];
                counter <= 0;
                state <= RS_WAIT;
            end

            RS_WAIT: begin
                if (counter >= RS_SETUP) begin
                    LCD_EN <= 1;
                    state <= EN_HIGH;
                    counter <= 0;
                end else counter <= counter + 1;
            end

            EN_HIGH: begin
                if (counter >= EN_PULSE) begin
                    LCD_EN <= 0;
                    state <= EN_LOW;
                    counter <= 0;
                end else counter <= counter + 1;
            end

            EN_LOW: begin
                state <= DELAY_5;
                counter <= 0;
            end

            DELAY_5: begin
                if (counter >= DELAY_5MS) begin
                    if (init) begin
                        cmd_index <= cmd_index + 1;
                        if (cmd_index < 9) state <= CMD_0 + cmd_index;
                        else begin
                            init <= 0;
                            state <= SEND_CHAR;
                        end
                    end else begin
                        state <= SEND_CHAR;
                        char_index <= char_index + 1;
                    end
                end else counter <= counter + 1;
            end

            SEND_CHAR: begin
                LCD_RS <= 1;
                LCD_RW <= 0;
                counter <= 0;
                case (char_index)
                    0: LCD_DATA <= " ";
                    1: LCD_DATA <= "a";
                    2: LCD_DATA <= "=";
                    3: LCD_DATA <= " ";
                    4: LCD_DATA <= nibble_to_ascii(a_in[7:4]);
                    5: LCD_DATA <= nibble_to_ascii(a_in[3:0]);
                    6: LCD_DATA <= " ";
                    7: LCD_DATA <= "n";
                    8: LCD_DATA <= " ";
                    9: LCD_DATA <= "=";
                    10: LCD_DATA <= " ";
                    11: LCD_DATA <= nibble_to_ascii(n_in[7:4]);
                    12: LCD_DATA <= nibble_to_ascii(n_in[3:0]);
                    13: LCD_DATA <= " ";
                    14: begin
                        LCD_RS <= 0;
                        LCD_DATA <= 8'hC1;
                        state <= RS_WAIT;
                        counter <= 0;
                    end
                    15: LCD_DATA <= "r";
                    16: LCD_DATA <= "e";
                    17: LCD_DATA <= "s";
                    18: LCD_DATA <= "=";
                    19: LCD_DATA <= nibble_to_ascii(res_in[15:12]);
                    20: LCD_DATA <= nibble_to_ascii(res_in[11:8]);
                    21: LCD_DATA <= nibble_to_ascii(res_in[7:4]);
                    22: LCD_DATA <= nibble_to_ascii(res_in[3:0]);
                    default: state <= DONE;
                endcase
                if (char_index < 23) state <= CHAR_RS_WAIT;
            end

            CHAR_RS_WAIT: begin
                if (counter >= RS_SETUP) begin
                    LCD_EN <= 1;
                    counter <= 0;
                    state <= CHAR_EN_HIGH;
                end else counter <= counter + 1;
            end

            CHAR_EN_HIGH: begin
                if (counter >= EN_PULSE) begin
                    LCD_EN <= 0;
                    counter <= 0;
                    state <= CHAR_EN_LOW;
                end else counter <= counter + 1;
            end

            CHAR_EN_LOW: begin
                counter <= 0;
                if (char_index < 23)
                    state <= DELAY_5;
                else
                    state <= DONE;
            end

            DONE: done <= 1;
            default: state <= IDLE;
        endcase
    end
end

endmodule

