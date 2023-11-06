`timescale 1ns / 1ps

/*******************************************************************
* Module: ALU_Control_Unit.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: recieves the funct7, funct3 and aluOp of the current
               instruction and uses them to assign the appropriate 
               ALU_Sel
* Change history: 26/09/23 – Created file in lab
                  03/11/23 – Added to case statment to include all 
                             instructions
**********************************************************************/


module ALU_Control_Unit
(
    input Funct_7,
    input [1:0] ALU_Op,
    input [2:0] Funct_3,
    output reg [3:0] ALU_Sel
);

    always @(*) begin
        case(ALU_Op)
            2'b00: ALU_Sel = 4'b0000;                                    //LOAD or STORE or JAL or JALR or AUIPC (ADD)

            2'b01: ALU_Sel = 4'b0001;                                    //BRANCH (SUB)
            
            2'b10: begin  //RTYPE - ITYPE
                case(Funct_3)
                    3'b000: ALU_Sel = Funct_7 ? 4'b0001 : 4'b0000;        //ADD : SUB
                    3'b001: ALU_Sel = 4'b1001;                           //SLL
                    3'b010: ALU_Sel = 4'b1101;                           //SLT
                    3'b011: ALU_Sel = 4'b1111;                           //SLTU
                    3'b100: ALU_Sel = 4'b0111;                           //XOR
                    3'b101: ALU_Sel = Funct_7 ? 4'b1010 : 4'b1000;        //SRA : SRL
                    3'b110: ALU_Sel = 4'b0100;                           //OR
                    3'b111: ALU_Sel = 4'b0101;                           //AND
                    default: ALU_Sel = 4'b0011;                          //PASS
                endcase
            end 

            2'b11: ALU_Sel = 4'b0011;                                    //LUI (PASS)

            default: ALU_Sel = 4'b0011;                                  //PASS
        endcase
    end

endmodule
