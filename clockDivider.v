`timescale 1ns / 1ps
/*******************************************************************
*
* Module: clockDivider.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: This module takes the clock from the FPGA which is 100mhz to make it depending on what is required in the project.
*
* Change history: 
* 17/05/2024 – File Created
**********************************************************************/
module clockDivider #(parameter n=250000) (
input clk,
input rst, 
output reg clk_out 
);
parameter width= $clog2(n);
reg [width-1:0] count;

always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) // Asynchronous Reset 
        count <= 32'b0;
    else if (count == n-1) 
        count <= 32'b0;
    else 
        count <= count + 1;
end
// Handle the output clock
always @ (posedge clk, posedge rst) begin
    if (rst) // Asynchronous Reset
        clk_out <= 0;
    else if (count == n-1)
        clk_out <= ~ clk_out;
end
endmodule
