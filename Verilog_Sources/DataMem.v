`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 05:08:22 PM
// Design Name: 
// Module Name: DataMem
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


module DataMem(
    input clk, 
    input MemRead, 
    input [1:0] funct3,
    input MemWrite, 
    input [7:0] addr, 
    input [31:0] data_in, 
    output reg [31:0] data_out); 
 
 reg [7:0] mem [0:255]; 
 
 always @ (posedge clk) begin
    if(MemWrite) begin 
      case(funct3) 
         3'b000: mem[addr] <= data_in[7:0]; //SB
         3'b001: begin
            mem[addr] <= data_in[7:0];
            mem[addr+1] <= data_in[15:8]; //SH
         end
         3'b010: begin
            mem[addr] <= data_in[7:0];
            mem[addr+1] <= data_in[15:8]; //SW
            mem[addr+2] <= data_in[23:16];
            mem[addr+3] <= data_in[31:24];
         end
      endcase
    end
    else
      mem[addr] <= mem[addr] ;
 end 

 always @(*) begin
   if(MemRead) begin
      case(funct3) 
            3'b000: data_out = {{24{mem[addr][7]}}, mem[addr]}; // LB
            3'b001: data_out = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]}; // LH
            3'b010: data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; // LW
            3'b100: data_out = {24'b0, mem[addr]}; // LBU
            3'b101: data_out = {16'b0, mem[addr+1], mem[addr]}; // LHU
      endcase 
   end
   else
      data_out = 32'b0;
 end
   
 initial begin 
//   {mem[3], mem[2], mem[1], mem[0]} = 32'd24; 
//   {mem[7], mem[6], mem[5], mem[4]} = 32'd2; 
//   {mem[11], mem[10], mem[9], mem[8]} = 32'b10000010;
//   {mem[15], mem[14], mem[13], mem[12]} = 32'b00000011; 
 end  

endmodule

