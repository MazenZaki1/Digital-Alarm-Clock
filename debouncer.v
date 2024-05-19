`timescale 1ns / 1ps
/*******************************************************************
*
* Module: debouncer.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: A debouncer for the button input detector.
*
* Change history: 
* 17/05/2024 – File Created
**********************************************************************/
module debouncer(input clk,
input rst, 
input in, 
output out
);
reg q1,q2,q3;
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1) begin
        q1 <= 0;
        q2 <= 0;
        q3 <= 0;
 end
    else begin
        q1 <= in;
        q2 <= q1;
        q3 <= q2;
    end
end
assign out = (rst) ? 0 : q1&q2&q3;
endmodule