// LCD_Controller.v
module LCD_Display_Controller (
    input clk,
    input rst,
    input start,
    input [31:0] a_val,
    input [31:0] n_val,
    input [31:0] res_val,
    output reg [7:0] LCD_DATA,
    output reg LCD_EN,
    output reg LCD_RS,
    output LCD_RW  // permanently write-only
);
    assign LCD_RW = 1'b0;

    reg [4:0] state;
    reg [5:0] msg_index;
    reg [19:0] delay;
    reg [7:0] message [0:39];  // allow extra space
    reg [31:0] a_latch, n_latch, res_latch;

    // States
    localparam INIT_WAIT = 0, INIT_1 = 1, INIT_2 = 2, INIT_3 = 3, INIT_4 = 4,
               IDLE = 5, LOAD = 6, WRITE = 7, HOLD = 8, WAIT = 9;

    // Initialization commands
    localparam CMD_FNSET = 8'h38;
    localparam CMD_DISP  = 8'h0C;
    localparam CMD_CLEAR = 8'h01;
    localparam CMD_ENTRY = 8'h06;

    // Converts 4-bit to ASCII hex char
    function [7:0] to_ascii;
        input [3:0] nibble;
        begin
            if (nibble < 10) to_ascii = "0" + nibble;
            else to_ascii = "A" + nibble - 10;
        end
    endfunction

    // Latch values and prepare message
    task load_message;
    begin
        a_latch <= a_val;
        n_latch <= n_val;
        res_latch <= res_val;

        message[0]  <= "a"; message[1]  <= "=";
        message[2]  <= to_ascii(a_val[15:12]);
        message[3]  <= to_ascii(a_val[11:8]);
        message[4]  <= to_ascii(a_val[7:4]);
        message[5]  <= to_ascii(a_val[3:0]);
        message[6]  <= " ";
        message[7]  <= "n"; message[8]  <= "=";
        message[9]  <= to_ascii(n_val[15:12]);
        message[10] <= to_ascii(n_val[11:8]);
        message[11] <= to_ascii(n_val[7:4]);
        message[12] <= to_ascii(n_val[3:0]);
        message[13] <= 8'hC0;  // new line command
        message[14] <= "r"; message[15] <= "e"; message[16] <= "s"; message[17] <= "=";
        message[18] <= to_ascii(res_val[31:28]);
        message[19] <= to_ascii(res_val[27:24]);
        message[20] <= to_ascii(res_val[23:20]);
        message[21] <= to_ascii(res_val[19:16]);
        message[22] <= to_ascii(res_val[15:12]);
        message[23] <= to_ascii(res_val[11:8]);
        message[24] <= to_ascii(res_val[7:4]);
        message[25] <= to_ascii(res_val[3:0]);
    end
    endtask

    // Main FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LCD_EN <= 0; LCD_RS <= 0;
            LCD_DATA <= 0;
            delay <= 0;
            state <= INIT_WAIT;
            msg_index <= 0;
        end else begin
            case (state)
                INIT_WAIT: begin
                    delay <= delay + 1;
                    if (delay > 20'd100_000) begin
                        delay <= 0;
                        state <= INIT_1;
                    end
                end
                INIT_1: begin LCD_RS <= 0; LCD_DATA <= CMD_FNSET; LCD_EN <= 1; state <= HOLD; end
                INIT_2: begin LCD_RS <= 0; LCD_DATA <= CMD_DISP;  LCD_EN <= 1; state <= HOLD; end
                INIT_3: begin LCD_RS <= 0; LCD_DATA <= CMD_CLEAR; LCD_EN <= 1; state <= HOLD; end
                INIT_4: begin LCD_RS <= 0; LCD_DATA <= CMD_ENTRY; LCD_EN <= 1; state <= HOLD; end
                IDLE: begin
                    LCD_EN <= 0;
                    if (start) begin
                        load_message();
                        msg_index <= 0;
                        state <= WRITE;
                    end
                end
                WRITE: begin
                    LCD_RS <= (message[msg_index] != 8'hC0);
                    LCD_DATA <= (message[msg_index] == 8'hC0) ? 8'h80 | 8'd64 : message[msg_index];
                    LCD_EN <= 1;
                    state <= HOLD;
                end
					 HOLD: begin
					 	delay <= delay + 1;
					 	if (delay < 25) begin
					 		LCD_EN <= 1;
					 	end else begin
					 		LCD_EN <= 0;
					 		delay <= 0;
					 		state <= WAIT;
					 	end
					 end
                WAIT: begin
                    delay <= delay + 1;
                    if (delay > 20'd3000) begin
                        if (state == INIT_1) state <= INIT_2;
                        else if (state == INIT_2) state <= INIT_3;
                        else if (state == INIT_3) state <= INIT_4;
                        else if (state == INIT_4) state <= IDLE;
                        else begin
                            msg_index <= msg_index + 1;
                            if (msg_index >= 26) state <= IDLE;
                            else state <= WRITE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
