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
  output reg [1:0] regWriteSel, 
  output reg MemWrite,
  output reg ALUSrc1,  
  output reg ALUSrc2, 
  output reg RegWrite,
  output reg [1:0] ALUOp
);

always @(*) begin 
case(Opcode)
5'b01100: begin //R-TYPE
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b10;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 0;
RegWrite = 1;
end

5'b00100: begin //Arith I-TYPE
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b10;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b00000: begin //LOAD
Branch = 0;
Jump = 0;
Mem_Read = 1;
regWriteSel = 2'b01;
ALUOp = 2'b0;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b01000: begin //STORE
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b0;
MemWrite = 1;
ALUSrc1 = 0;
ALUSrc2 = 1;
RegWrite = 0;
end

5'b11000: begin //Branch
Branch = 1;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b01;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 0;
RegWrite = 0;
end 

5'b11011: begin //JAL
Branch = 0;
Jump = 1;
Mem_Read = 0;
regWriteSel = 2'b10;
ALUOp = 2'b00;
MemWrite = 0;
ALUSrc1 = 1;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b11001: begin //JALR
Branch = 0;
Jump = 1;
Mem_Read = 0;
regWriteSel = 2'b10;
ALUOp = 2'b00;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b01101: begin //LUI
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b11;
ALUOp = 2'b11;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b00101: begin //AUIPC
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b00;
MemWrite = 0;
ALUSrc1 = 1;
ALUSrc2 = 1;
RegWrite = 1;
end

5'b11100: begin //EBREAK or ECALL
Branch = 0;
Jump = 0;
Mem_Read = 0;
regWriteSel = 2'b00;
ALUOp = 2'b11;
MemWrite = 0;
ALUSrc1 = 0;
ALUSrc2 = 0;
RegWrite = 0;
end

5'b00011: begin //FENCE
Branch = 0;
Jump = 0;
Mem_Read = 0;
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