`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 04:54:54 PM
// Design Name: 
// Module Name: InstMem
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


module InstMem (input [7:0] addr, output [31:0] data_out); 
 reg [7:0] mem [0:255]; 
 
  initial begin 
    {mem[3], mem[2], mem[1], mem[0]} = 32'b00000000000100000000001010010011; //addi t0, zero, 1 # x = 1

{mem[7], mem[6], mem[5], mem[4]} = 32'b00000000000000000000001100010011; //addi t1, zero, 0 # i = 0 

{mem[11], mem[10], mem[9], mem[8]} = 32'b00000000011000000000001110010011; //addi t2, zero, 6 # y = 6

{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000011100101000101001100011; //beq t0, t2, endStore # i == y?

{mem[19], mem[18], mem[17], mem[16]} = 32'b00000000010100110010000000100011; //sw t0, 0(t1)	# mem[i] = x

{mem[23], mem[22], mem[21], mem[20]} = 32'b00000000010000110000001100010011; //addi t1, t1, 4	# i+=4

{mem[27], mem[26], mem[25], mem[24]} = 32'b00000000000100101000001010010011; //addi t0, t0, 1	# x++

{mem[31], mem[30], mem[29], mem[28]} = 32'b11111110000000000000100011100011; //beq zero, zero, store # loop back

{mem[35], mem[34], mem[33], mem[32]} = 32'b00000000000000000000001010010011; //addi t0, zero, 0 # i = 0

{mem[39], mem[38], mem[37], mem[36]} = 32'b00000000000000000000001100010011; //addi t1, zero, 0 # *i 

{mem[43], mem[42], mem[41], mem[40]} = 32'b00000001000000000000001110010011; //addi t2, zero, 16 # *(4-i)

{mem[47], mem[46], mem[45], mem[44]} = 32'b00000000001100000000111000010011; //addi t3, zero, 3 # x = 3

{mem[51], mem[50], mem[49], mem[48]} = 32'b00000011110000101000001001100011; //beq t0, t3, endSwap # i == x?

{mem[55], mem[54], mem[53], mem[52]} = 32'b00000000000000110010111010000011; //lw t4, 0(t1) # temp1 = mem[i]

{mem[59], mem[58], mem[57], mem[56]} = 32'b00000000000000111010111100000011; //lw t5, 0(t2) # temp2 = mem[4-i]

{mem[63], mem[62], mem[61], mem[60]} = 32'b00000001110100111010000000100011; //sw t4, 0(t2) # mem[4-i] = temp1

{mem[67], mem[66], mem[65], mem[64]} = 32'b00000001111000110010000000100011; //sw t5, 0(t1) # mem[i] = temp2

{mem[71], mem[70], mem[69], mem[68]} = 32'b00000000000100101000001010010011; //addi t0, t0, 1 # i++

{mem[75], mem[74], mem[73], mem[72]} = 32'b00000000010000110000001100010011; //addi t1, t1, 4 # *(i+1)     

{mem[79], mem[78], mem[77], mem[76]} = 32'b11111111110000111000001110010011; //addi t2, t2, -4 # *(4-i-1)     

{mem[83], mem[82], mem[81], mem[80]} = 32'b11111110000000000000000011100011; //beq zero, zero, swap # loop back


 end 
 
 assign data_out[7:0] = mem[addr];
 assign data_out[15:8] = mem[addr+1];
 assign data_out[23:16] = mem[addr+2];
 assign data_out[31:24] = mem[addr+3];

endmodule
