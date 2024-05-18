`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 04:22:11 PM
// Design Name: 
// Module Name: SevenSegDecWithEn
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

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