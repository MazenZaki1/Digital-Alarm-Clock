`timescale 1ns / 1ps
/*******************************************************************
*
* Module: SevenSegDecWithEn.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: This module is called in digital clock to display a digit in the 7 segment digits on the FPGA.
*
* Change history: 
* 17/05/2024 – File created
* 18/05/2024 - Created all the states and modified them accordingly.
*
**********************************************************************/
module SevenSegDecWithEn(
input [3:0] num,
output reg [6:0] segments
);
    always @ (*) begin
            case(num)
                0: segments = 7'b0000001; // 0
                1: segments = 7'b1001111; // 1
                2: segments = 7'b0010010; // 2
                3: segments = 7'b0000110; // 3
                4: segments = 7'b1001100; // 4
                5: segments = 7'b0100100; // 5
                6: segments = 7'b0100000; // 6
                7: segments = 7'b0001111; // 7
                8: segments = 7'b0000000; // 8
                9: segments = 7'b0000100; // 9
                default: segments=7'b00000001;
            endcase
        end
endmodule