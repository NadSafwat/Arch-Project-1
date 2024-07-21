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

module Branch_Control_Unit(
    input [2:0] funct3,
    input Zflag,
    input Sflag,
    input Vflag,
    input Cflag,
    input Branch,
    output reg BranchAnd
);

always @(*) begin
    case(funct3)
        3'b000: BranchAnd = Branch & Zflag;
        3'b001: BranchAnd = Branch & ~Zflag;
        3'b100: BranchAnd = Branch & (Sflag != Vflag);
        3'b101: BranchAnd = Branch & (Sflag == Vflag);
        3'b110: BranchAnd = Branch & ~Cflag;
        3'b111: BranchAnd = Branch & Cflag;
        default: BranchAnd = 1'b0;
    endcase
end

endmodule