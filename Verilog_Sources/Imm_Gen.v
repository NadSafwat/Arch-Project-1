`timescale 1ns / 1ps

/*******************************************************************
* Module: Imm_Gen.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module receives the 32 bit Instuction and extracts 
               the 32 bit immediate value from it depending on the Opcode
               of the incoming Instruction. It also takes into account the 
               sign extension of the immediate value.
* Change history: 19/09/23 – Created module in lab
                  03/11/23 - edited module to include all Instructions
**********************************************************************/

module Imm_Gen 
( 
   input [6:0] Opcode;
   input [3:0] Funct7_3;
   output reg [31:0] Gen_Out
);

   always @(*) begin
      case(Opcode)
         7'b0000011: begin //LOAD I-Type
            Gen_Out = { {20{Inst[31]}}, Inst[31:20] } ;
         end

         7'b0010011: begin //ARITH I-Type
            Gen_Out = (Funct7_3 == 4'b1101) ? { 27'b0 , Inst[24:20] } : { {20{Inst[31]}}, Inst[31:20] } ;
         end   

         7'b1100111: begin //JALR
            Gen_Out = { {20{Inst[31]}}, Inst[31:20] } ;
         end             

         7'b0100011: begin //S-Type
            Gen_Out = { {20{Inst[31]}}, Inst[31:25], Inst[11:7] } ;
         end

         7'b1100011: begin //B-Type
            Gen_Out = { {19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8],1'b0 } ;
         end

         7'b1101111: begin //JAL
            Gen_Out = { {11{Inst[31]}}, Inst[31], Inst[19:12], Inst[20], Inst[30:21], 1'b0} ;
         end

         7'b0110111: begin //LUI
            Gen_Out = { Inst[31:12], 12'b0 } ;
         end

         7'b0010111: begin//AUIPC
            Gen_Out = { Inst[31:12], 12'b0 } ;
         end

         default: begin
            Gen_Out = 32'b0;
         end
      endcase 
   end                    
endmodule