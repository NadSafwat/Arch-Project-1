`timescale 1ns / 1ps

/*******************************************************************
* Module: Reg_File.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module takes in 3 5 bit inputs which represent the 
               register numbers of the 2 source registers and the destination
               register. It also takes in an n bit input which is the data to 
               be written into the register file.It has 2 n bit outputs which
               are the data read from the 2 source registers.
* Change history: 26/09/23 – Created module in lab
*******************************************************************************/

module Reg_File #(parameter n = 32)(
    input clk,
    input rst,
    input Reg_Write,
    input [4:0] RS1,
    input [4:0] RS2,
    input [4:0] RD,
    input [n-1:0] Write_Data,
    output [n-1:0] Read_Data1,
    output [n-1:0] Read_Data2
    );
    
    reg [n-1:0] Registers [31:0];
    integer i;

    always @ (negedge clk or posedge rst) begin
        if(rst == 1'b1) begin
            for(i = 0; i < n; i = i+1) begin
                Registers[i] <= 0;
            end
        end
        
        else if(Reg_Write == 1'b1) begin
            if(RD != 0) 
                Registers[RD] <= Write_Data;
            else
                Registers[RD] <= 32'b0;
        end
    end 

    assign Read_Data1 = Registers[RS1];
    assign Read_Data2 = Registers[RS2];
endmodule

