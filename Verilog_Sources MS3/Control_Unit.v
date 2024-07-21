`timescale 1ns / 1ps

/*******************************************************************
* Module: Control_Unit.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: Will read the last 5 bits of the opcode of the current 
               instuction and will use it to assign the appropriate 
               cointrol signals to be used by the rest of the program
* Change history: 00/10/23 – Created module in lab
                  03/11/23 - edited module to include all instructions
**********************************************************************/


module Control_Unit(
  input [4:0] opcode,
  output reg branch,
  output reg Jump, 
  output reg MemRead, 
  output reg [1:0] regWriteSel, 
  output reg MemWrite,
  output reg ALUSrc1,  
  output reg ALUSrc2, 
  output reg RegWrite,
  output reg [1:0] ALUOp
  );

  always @(*) begin 
    case(opcode)
      5'b01100: begin //R-TYPE
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b10;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 1;
        end
      
      5'b00100: begin //Arith I-TYPE
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b10;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
        end
        
      5'b00000: begin //LOAD
        branch = 0;
        Jump = 0;
        MemRead = 1;
        regWriteSel = 2'b01;
        ALUOp = 2'b0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
        end
        
      5'b01000: begin //STORE
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b0;
        MemWrite = 1;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 0;
        end
        
      5'b11000: begin //BRANCH
        branch = 1;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b01;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
        end 
      
      5'b11011: begin //JAL
        branch = 0;
        Jump = 1;
        MemRead = 0;
        regWriteSel = 2'b10;
        ALUOp = 2'b00;
        MemWrite = 0;
        ALUSrc1 = 1;
        ALUSrc2 = 1;
        RegWrite = 1;
      end

      5'b11001: begin //JALR
        branch = 0;
        Jump = 1;
        MemRead = 0;
        regWriteSel = 2'b10;
        ALUOp = 2'b00;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
      end

      5'b01101: begin //LUI
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b11;
        ALUOp = 2'b11;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
      end

      5'b00101: begin //AUIPC
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b00;
        MemWrite = 0;
        ALUSrc1 = 1;
        ALUSrc2 = 1;
        RegWrite = 1;
      end

      5'b11100: begin //EBREAK or ECALL
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b11;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
      end

      5'b00011: begin //FENCE
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b11;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
      end
      
      default: begin //NOP
        branch = 0;
        Jump = 0;
        MemRead = 0;
        regWriteSel = 2'b00;
        ALUOp = 2'b11;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
      end 
    endcase
      
  end        
endmodule

