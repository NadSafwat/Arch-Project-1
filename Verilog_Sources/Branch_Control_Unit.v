`timescale 1ns / 1ps

/*******************************************************************
* Module: Branch_Control_Unit.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: Using the Funct_3 of the given instruction and the flags 
               calculated in the ALU, the branch control unit will assess 
               these flags and will return a signal to branch or not
* Change history: 03/11/23 – Created module 
**********************************************************************/


module Branch_Control_Unit
(
    input [2:0] Funct_3,
    input Z_Flag,
    input S_Flag,
    input V_Flag,
    input C_Flag,
    input Branch,
    output reg Branch_And
);

always @(*) begin
    case(Funct_3)
        3'b000: Branch_And = Branch & Z_Flag;
        3'b001: Branch_And = Branch & ~Z_Flag;
        3'b100: Branch_And = Branch & (S_Flag != V_Flag);
        3'b101: Branch_And = Branch & (S_Flag == V_Flag);
        3'b110: Branch_And = Branch & ~C_Flag;
        3'b111: Branch_And = Branch & C_Flag;
        default: Branch_And = 1'b0;
    endcase
end

endmodule