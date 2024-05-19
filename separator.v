`timescale 1ns / 1ps
/*******************************************************************
*
* Module: separator.v
* Project: Digital-Alarm-Clock
* Author: Mazen Zaki (mazen.zaki@aucegypt.edu), Abdelrahman Taher Elessawy (elessawy@aucegypt.edu), Mohanad Hassan Saad (mohanadsamy@aucegypt.edu), Mustafa El Mahdy (mustafaelmahdy@aucegypt.edu)
* Description: This module takes a number as input and seperates the tens from the ones in that number.
*
* Change history: 
* 17/05/2024 – File created
*
**********************************************************************/
module separator( 
input [5:0] number,
output [3:0] tens,
output [3:0] units
);

 assign tens = (number / 10)%10;
 assign units = number % 10;
    
endmodule
