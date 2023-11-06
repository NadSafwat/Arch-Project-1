`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 06:10:03 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit
(
  input [4:0] Opcode,
  output reg Branch,
  output reg Jump, 
  output reg Mem_Read, 
  output reg [1:0] Reg_Write_Sel, 
  output reg Mem_Write,
  output reg ALU_Src_1,  
  output reg ALU_Src_2, 
  output reg Reg_Write,
  output reg [1:0] ALU_Op
);

  always @(*) begin 
    case(Opcode)
    5'b01100: 
      begin //R-TYPE
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b10;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 0;
        Reg_Write = 1;
      end

    5'b00100: 
      begin //Arith I-TYPE
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b10;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b00000: 
      begin //LOAD
        Branch = 0;
        Jump = 0;
        Mem_Read = 1;
        Reg_Write_Sel = 2'b01;
        ALU_Op = 2'b0;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b01000: 
      begin //STORE
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b0;
        Mem_Write = 1;
        ALU_Src_1 = 0;
        ALU_Src_2 = 1;
        Reg_Write = 0;
      end

    5'b11000: 
      begin //Branch
        Branch = 1;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b01;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 0;
        Reg_Write = 0;
      end 

    5'b11011: 
      begin //JAL
        Branch = 0;
        Jump = 1;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b10;
        ALU_Op = 2'b00;
        Mem_Write = 0;
        ALU_Src_1 = 1;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b11001: 
      begin //JALR
        Branch = 0;
        Jump = 1;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b10;
        ALU_Op = 2'b00;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b01101:
      begin //LUI
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b11;
        ALU_Op = 2'b11;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b00101: 
      begin //AUIPC
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b00;
        Mem_Write = 0;
        ALU_Src_1 = 1;
        ALU_Src_2 = 1;
        Reg_Write = 1;
      end

    5'b11100: 
      begin //EBREAK or ECALL
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b11;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 0;
        Reg_Write = 0;
      end

    5'b00011: 
      begin //FENCE
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b11;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 0;
        Reg_Write = 0;
      end
    
    default: 
      begin
        Branch = 0;
        Jump = 0;
        Mem_Read = 0;
        Reg_Write_Sel = 2'b00;
        ALU_Op = 2'b11;
        Mem_Write = 0;
        ALU_Src_1 = 0;
        ALU_Src_2 = 0;
        Reg_Write = 0;
      end
    endcase
  end        
endmodule