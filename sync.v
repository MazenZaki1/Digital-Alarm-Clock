`timescale 1ns / 1ps
/*******************************************************************
*
* Module: sync.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: 
*
* Change history: 
* 17/05/2024 – File created
* 18/05/2024 - Created all the states and modified them accordingly.
*
**********************************************************************/
module sync(input clk,
input sig, 
output reg sig1
);
reg meta;
always @ (posedge clk) begin
    meta <= sig;
    sig1<=meta;
end
endmodule