`timescale 1ns / 1ps
/*******************************************************************
*
* Module: risingEdgeDetector.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: Rising edge detector.
*
* Change history: 
* 17/05/2024 – File created
*
**********************************************************************/
module risingEdgeDetector(input clk, rst, w, output z);
reg [1:0] state, nextState;
parameter [1:0] A=2'b00, B=2'b01, C=2'b10; // States Encoding
// Next state generation (combinational logic)
always @ (w or state)
case (state)
A: if (w==1) nextState = B;
 else nextState = A;
B: if (w==1) nextState = C;
 else nextState = A;
C: if (w==1) nextState = C;
 else nextState = A;
default: nextState = A;
endcase
// State register
// Update state FF's with the triggering edge of the clock
always @ (posedge clk or posedge rst) begin
if(rst) state <= A;
else state <= nextState;
end
// output generation (combinational logic)
assign z = (state == B);
endmodule

