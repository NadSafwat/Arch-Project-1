`timescale 1ns / 1ps

/*******************************************************************
* Module: Forwarding_Unit.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module takes and the RS1,RS2 in the EX stage and RD
		in both MEM and WB stages and checks if the EX and MEM 
		hazard conditions were met which checks if there are any 
		read after write hazards. It then sets the forward_A and 
		forward_B signals accordingly to forward.
* Change history: 17/11/23 – Created module in lab
*******************************************************************************/



module Forwarding_Unit
(
    input [4:0] RS1_EX,
    input [4:0] RS2_EX,
    input [4:0] RD_MEM,
    input [4:0] RD_WB,
    input RegWrite_MEM,
    input RegWrite_WB,
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
);

always @(*) begin
//EX HAZARD
    if ( RegWrite_MEM && (RD_MEM != 5'b0) && (RD_MEM == RS1_EX) ) 
        Forward_A = 2'b10;
    else if (( RegWrite_WB && (RD_WB != 5'b0) && (RD_WB == RS1_EX) ) && ~(RegWrite_MEM && (RD_MEM != 5'b0) && (RD_MEM == RS1_EX) ) )
        Forward_A = 2'b01;
    else 
        Forward_A = 2'b00;
        
    if ( RegWrite_MEM && (RD_MEM != 5'b0) && (RD_MEM == RS2_EX) ) 
        Forward_B = 2'b10;
    else if (( RegWrite_WB && (RD_WB!=5'b0) && (RD_WB == RS2_EX) )  && ~( RegWrite_MEM && (RD_MEM != 5'b0) && (RD_MEM == RS2_EX) ) )
        Forward_B = 2'b01; 
    else
        Forward_B = 2'b00; 
end

endmodule