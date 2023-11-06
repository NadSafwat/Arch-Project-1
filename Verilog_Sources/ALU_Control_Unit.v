`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 06:32:58 PM
// Design Name: 
// Module Name: ALU_Control_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_Control_Unit(
    input [2:0] funct3,
    input funct7,
    input [1:0] ALUop,
    output reg [3:0] ALUSel
    );

always @(*) begin
case(ALUop)
    2'b00: ALUSel = 4'b0000;                                    //LOAD or STORE or JAL or JALR or AUIPC (ADD)

    2'b01: ALUSel = 4'b0001;                                    //BRANCH (SUB)
    
    2'b10: begin  //RTYPE - ITYPE
        case(funct3)
            3'b000: ALUSel = funct7 ? 4'b0001 : 4'b0000;        //ADD : SUB
            3'b001: ALUSel = 4'b1001;                           //SLL
            3'b010: ALUSel = 4'b1101;                           //SLT
            3'b011: ALUSel = 4'b1111;                           //SLTU
            3'b100: ALUSel = 4'b0111;                           //XOR
            3'b101: ALUSel = funct7 ? 4'b1010 : 4'b1000;        //SRA : SRL
            3'b110: ALUSel = 4'b0100;                           //OR
            3'b111: ALUSel = 4'b0101;                           //AND
        endcase
    end 

    2'b11: ALUSel = 4'b0011;                                    //LUI
endcase
end

endmodule
