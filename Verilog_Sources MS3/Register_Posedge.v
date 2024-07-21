`timescale 1ns / 1ps

/*******************************************************************
* Module: Register_Poseedge.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module makes the register store data at the positve
	       egde of the clock.
* Change history: 25/11/23 – Created module
*******************************************************************************/


module Register_Posedge #(parameter n = 64)(
    input clk,
    input rst,
    input Load,
    input [n-1:0] D,
    output reg [n-1:0] Q
    );
    
    wire [n-1:0] mux_out; 
    
    always @ (posedge clk or posedge rst) begin
        if(rst == 1)
            Q <= 0;
        else if (Load == 1)
            Q <= D;
    end
endmodule