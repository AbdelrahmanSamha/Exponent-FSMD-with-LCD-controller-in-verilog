# Single purpose exponent calculator with LCD controller

the project is a FSMD that calculate A to the power of N. sizing of the registers are 8,8 respectively to produce a 16 bit result. 
the main feature of this project is a Static LCD controller. 
the LCD controller is found in abd_lcd_initializer.v 
Do NOT modify the states that contian : 
En signal,
RS signal, 
Counter for delay.

the only thing you need to change is case statement which is in the SEND_CHAR state. 
the programmer must also change the limits of char_index accross the file, depending on how many characters they want to display. 
you may need to change the input ports to the module based on your demand. 

to send an instruction you can add more statement to the command_seq array based on your needs. note that with the current configration, instructions are only sent on power up. you may need to change the FSM a little after the SEND_CHAR state to 
send instructions after displaying characters. 

(note: the crucial part of the LCD display is the delay, and in this project i used a fixed delay of 5ms for the most part beside the power up which needs 15ms, if your use case requires quicker response you must either follow your LCD manufacturer manual 
or read the busy flag by sending a special instruction. the LCD in the DE2-115 board used for this project is Hitachi HD44780 LCD.) 

provided below is the .QSF file which contains the neccessary pin assignment TCL commands for the altera DE2-115 Board: 
(note that assignment to pins may change depending on the FPGA board you are using. ) 

set_location_assignment PIN_L6 -to LCD_BLON
set_location_assignment PIN_M5 -to LCD_DATA[7]
set_location_assignment PIN_M3 -to LCD_DATA[6]
set_location_assignment PIN_K2 -to LCD_DATA[5]
set_location_assignment PIN_K1 -to LCD_DATA[4]
set_location_assignment PIN_K7 -to LCD_DATA[3]
set_location_assignment PIN_L2 -to LCD_DATA[2]
set_location_assignment PIN_L1 -to LCD_DATA[1]
set_location_assignment PIN_L3 -to LCD_DATA[0]
set_location_assignment PIN_L4 -to LCD_EN
set_location_assignment PIN_L5 -to LCD_ON
set_location_assignment PIN_H15 -to LCD_OVER
set_location_assignment PIN_M2 -to LCD_RS
set_location_assignment PIN_M1 -to LCD_RW

# the rest are required for stuff other than the LCD for  the project it self. 

set_location_assignment PIN_AB28 -to a_i[0]
set_location_assignment PIN_AC28 -to a_i[1]
set_location_assignment PIN_AC27 -to a_i[2]
set_location_assignment PIN_AD27 -to a_i[3]
set_location_assignment PIN_AB27 -to a_i[4]
set_location_assignment PIN_AC26 -to a_i[5]
set_location_assignment PIN_AD26 -to a_i[6]
set_location_assignment PIN_AB26 -to a_i[7]
set_location_assignment PIN_Y2 -to clk
set_location_assignment PIN_M23 -to rst
set_location_assignment PIN_G16 -to sig_done
set_location_assignment PIN_AC25 -to n_i[0]
set_location_assignment PIN_AB25 -to n_i[1]
set_location_assignment PIN_AC24 -to n_i[2]
set_location_assignment PIN_AB24 -to n_i[3]
set_location_assignment PIN_AB23 -to n_i[4]
set_location_assignment PIN_AA24 -to n_i[5]
set_location_assignment PIN_AA23 -to n_i[6]
set_location_assignment PIN_AA22 -to n_i[7]
set_location_assignment PIN_M21 -to go_i
set_location_assignment PIN_G19 -to output_reg[0]
set_location_assignment PIN_F19 -to output_reg[1]
set_location_assignment PIN_E19 -to output_reg[2]
set_location_assignment PIN_F21 -to output_reg[3]
set_location_assignment PIN_F18 -to output_reg[4]
set_location_assignment PIN_E18 -to output_reg[5]
set_location_assignment PIN_J19 -to output_reg[6]
set_location_assignment PIN_H19 -to output_reg[7]
set_location_assignment PIN_J17 -to output_reg[8]
set_location_assignment PIN_G17 -to output_reg[9]
set_location_assignment PIN_J15 -to output_reg[10]
set_location_assignment PIN_H16 -to output_reg[11]
set_location_assignment PIN_J16 -to output_reg[12]
set_location_assignment PIN_H17 -to output_reg[13]
set_location_assignment PIN_F15 -to output_reg[14]
set_location_assignment PIN_G15 -to output_reg[15]
set_location_assignment PIN_G18 -to seg4[0]
set_location_assignment PIN_F22 -to seg4[1]
set_location_assignment PIN_E17 -to seg4[2]
set_location_assignment PIN_L26 -to seg4[3]
set_location_assignment PIN_L25 -to seg4[4]
set_location_assignment PIN_J22 -to seg4[5]
set_location_assignment PIN_H22 -to seg4[6]
set_location_assignment PIN_M24 -to seg5[0]
set_location_assignment PIN_Y22 -to seg5[1]
set_location_assignment PIN_W21 -to seg5[2]
set_location_assignment PIN_W22 -to seg5[3]
set_location_assignment PIN_W25 -to seg5[4]
set_location_assignment PIN_U23 -to seg5[5]
set_location_assignment PIN_U24 -to seg5[6]
set_location_assignment PIN_AA25 -to seg6[0]
set_location_assignment PIN_AA26 -to seg6[1]
set_location_assignment PIN_Y25 -to seg6[2]
set_location_assignment PIN_W26 -to seg6[3]
set_location_assignment PIN_Y26 -to seg6[4]
set_location_assignment PIN_W27 -to seg6[5]
set_location_assignment PIN_W28 -to seg6[6]
set_location_assignment PIN_V21 -to seg7[0]
set_location_assignment PIN_U21 -to seg7[1]
set_location_assignment PIN_AB20 -to seg7[2]
set_location_assignment PIN_AA21 -to seg7[3]
set_location_assignment PIN_AD24 -to seg7[4]
set_location_assignment PIN_AF23 -to seg7[5]
set_location_assignment PIN_Y19 -to seg7[6]
set_location_assignment PIN_AB19 -to seg2[0]
set_location_assignment PIN_AA19 -to seg2[1]
set_location_assignment PIN_AG21 -to seg2[2]
set_location_assignment PIN_AH21 -to seg2[3]
set_location_assignment PIN_AE19 -to seg2[4]
set_location_assignment PIN_AF19 -to seg2[5]
set_location_assignment PIN_AE18 -to seg2[6]
set_location_assignment PIN_AD18 -to seg3[0]
set_location_assignment PIN_AC18 -to seg3[1]
set_location_assignment PIN_AB18 -to seg3[2]
set_location_assignment PIN_AH19 -to seg3[3]
set_location_assignment PIN_AG19 -to seg3[4]
set_location_assignment PIN_AF18 -to seg3[5]
set_location_assignment PIN_AH18 -to seg3[6]
set_location_assignment PIN_AA17 -to seg0[0]
set_location_assignment PIN_AB16 -to seg0[1]
set_location_assignment PIN_AA16 -to seg0[2]
set_location_assignment PIN_AB17 -to seg0[3]
set_location_assignment PIN_AB15 -to seg0[4]
set_location_assignment PIN_AA15 -to seg0[5]
set_location_assignment PIN_AC17 -to seg0[6]
set_location_assignment PIN_AD17 -to seg1[0]
set_location_assignment PIN_AE17 -to seg1[1]
set_location_assignment PIN_AG17 -to seg1[2]
set_location_assignment PIN_AH17 -to seg1[3]
set_location_assignment PIN_AF17 -to seg1[4]
set_location_assignment PIN_AG18 -to seg1[5]
set_location_assignment PIN_AA14 -to seg1[6]
