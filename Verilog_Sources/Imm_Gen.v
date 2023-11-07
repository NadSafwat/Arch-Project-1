`timescale 1ns / 1ps
/*******************************************************************
* Module: Imm_Gen.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module receives the 32 bit instuction and extracts 
               the 32 bit immediate value from it depending on the opcode
               of the incoming instruction. It also takes into account the 
               sign extension of the immediate value.
* Change history: 19/09/23 – Created module in lab
                  03/11/23 - edited module to include all instructions
**********************************************************************/


module Imm_Gen (
    output reg [31:0] gen_out, 
    input [31:0] inst
    );
    
    wire [6:0] opcode;
    wire [3:0] funct7_3;
    
    assign opcode = inst[6:0];
    assign funct7_3 = {inst[30], inst[14:12]};

    always @(*) begin
       case(opcode)
           7'b0000011: begin //LOAD I-Type
              gen_out = { {20{inst[31]}}, inst[31:20] } ;
              end
               
           7'b0010011: begin //ARITH I-Type
              gen_out = (funct7_3 == 4'b1101) ? { 27'b0 , inst[24:20] } : { {20{inst[31]}}, inst[31:20] } ;
              end   
              
           7'b1100111: begin //JALR
              gen_out = { {20{inst[31]}}, inst[31:20] } ;
              end             
               
           7'b0100011: begin //S-Type
              gen_out = { {20{inst[31]}}, inst[31:25], inst[11:7] } ;
              end
               
           7'b1100011: begin //B-Type
              gen_out = { {19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8],1'b0 } ;
              end
           
           7'b1101111: begin //JAL
              gen_out = { {11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0} ;
              end
           
           7'b0110111: begin //LUI
              gen_out = { inst[31:12], 12'b0 } ;
              end
        
           7'b0010111: begin//AUIPC
              gen_out = { inst[31:12], 12'b0 } ;
              end
              
            default: begin
              gen_out = 32'b0;
              end
       endcase 
    end                    

endmodule
