`timescale 1ns / 1ps

/*******************************************************************
* Module: Data_Mem.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: Recieves an adress from the ALU, if the read signal 
               is on, the function will use the given funct 3 to 
               read the required number of bytes and whether to sign 
               extend or not, if the MemWrite signal is on it will 
               use the funct3 to write the required number of bits
* Change history: 00/10/23 – Created module in lab
                  03/11/23 - edited module to include all instructions
		  26/11/23 - edited this module to be a single memory containing 
			     both the instructions and the data memory.
**********************************************************************/



module Memory(
    input clk, 
    input MemRead, 
    input [2:0] funct3,
    input MemWrite, 
    input [7:0] addr, 
    input [31:0] data_in, 
    output reg [31:0] data_out); 
 
 reg [7:0] mem [0:255]; 
 
 always @ (posedge clk) begin
    if(MemWrite == 1'b1) begin 
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
         default: begin
            mem[addr] <= mem[addr];
            mem[addr+1] <= mem[addr+1]; //SW
            mem[addr+2] <= mem[addr+2];
            mem[addr+3] <= mem[addr+3];
            

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
            default: data_out = 32'b0;
      endcase 
   end
   else
      data_out = 32'b0;
 end
 
// Data starts at mem[0]
// Instructions start at mem[128]
 initial begin 
{mem[3], mem[2], mem[1], mem[0]} = 32'b00000000000000000010000010110111; 
{mem[7], mem[6], mem[5], mem[4]} = 32'b00000000000000000101000100010111; 
{mem[11], mem[10], mem[9], mem[8]} = 32'b00000000100000000000000111101111;
{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000000100000000000001110011; 
{mem[19], mem[18], mem[17], mem[16]} = 32'b00000000001000001001010001100011; 
{mem[23], mem[22], mem[21], mem[20]} = 32'b00000000000000000000000001110011; 
{mem[27], mem[26], mem[25], mem[24]} = 32'b11111100100000000000001000010011; 
{mem[31], mem[30], mem[29], mem[28]} = 32'b00000000001000001100010001100011; 
{mem[35], mem[34], mem[33], mem[32]} =32'b00000000000000000000000001110011; 
{mem[39], mem[38], mem[37], mem[36]} = 32'b00000000001000000000000000100011; 
{mem[43], mem[42], mem[41], mem[40]} = 32'b00000000000100010101010001100011; 
{mem[47], mem[46], mem[45], mem[44]} = 32'b00000000000000000000000001110011; 
{mem[51], mem[50], mem[49], mem[48]} = 32'b00000000010000001110010001100011;
{mem[55], mem[54], mem[53], mem[52]} = 32'b00000000000000000000000001110011; 
{mem[59], mem[58], mem[57], mem[56]} =32'b00000000001000100111010001100011;
{mem[63], mem[62], mem[61], mem[60]} = 32'b00000000000000000000000001110011; 
{mem[67], mem[66], mem[65], mem[64]} =32'b00000000010000000001000010100011; 
{mem[71], mem[70], mem[69], mem[68]} =32'b00000000000000000000000001110011;
{mem[75], mem[74], mem[73], mem[72]} =32'b00001111111100000000000000001111;  
{mem[79], mem[78], mem[77], mem[76]} = 32'b00000000000000000001000000001111;    
{mem[83], mem[82], mem[81], mem[80]} = 32'b00000000000000011000000001100111; 





 end  

endmodule

