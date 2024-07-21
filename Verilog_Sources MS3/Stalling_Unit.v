`timescale 1ns / 1ps

/*******************************************************************
* Module: Stalling_Unit.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module takes and the RS1,RS2 in the ID stage and RD
		EX stage and checks if the load use hazard conditions
		were met. It then sets the forward_A and forward_B 
		signals accordingly to forward.
* Change history: 17/11/23 – Created module in lab
*******************************************************************************/



module Stalling_Unit(
    input [4:0] RS1_ID,
    input [4:0] RS2_ID,
    input [4:0] RD_EX,
    input MemRead_EX,
    output reg Stall
    );
    
    always @(*) begin
        if (( (RS1_ID==RD_EX) || (RS2_ID==RD_EX) ) && MemRead_EX && (RD_EX != 5'b0))
            Stall = 1'b1;
        else 
            Stall = 1'b0;
    end
endmodule
