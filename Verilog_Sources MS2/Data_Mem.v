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
**********************************************************************/

module Data_Mem
(
   input clk, 
   input Mem_Read, 
   input Mem_Write, 
   input [1:0] Funct_3,
   input [7:0] Addr, 
   input [31:0] Data_In, 
   output reg [31:0] Data_Out
); 
 
   reg [7:0] Mem [0:255]; 

   always @ (posedge clk) begin
      if(Mem_Write) begin 
         case(Funct_3) 
            3'b000: Mem[Addr] <= Data_In[7:0]; //SB

            3'b001: begin
               Mem[Addr] <= Data_In[7:0];
               Mem[Addr+1] <= Data_In[15:8]; //SH
            end

            3'b010: begin
               Mem[Addr] <= Data_In[7:0];
               Mem[Addr+1] <= Data_In[15:8]; //SW
               Mem[Addr+2] <= Data_In[23:16];
               Mem[Addr+3] <= Data_In[31:24];
            end
         endcase
      end
      else
         Mem[Addr] <= Mem[Addr] ;
   end 

   always @(*) begin
      if(Mem_Read) begin
         case(Funct_3) 
               3'b000: Data_Out = {{24{Mem[Addr][7]}}, Mem[Addr]}; // LB
               3'b001: Data_Out = {{16{Mem[Addr+1][7]}}, Mem[Addr+1], Mem[Addr]}; // LH
               3'b010: Data_Out = {Mem[Addr+3], Mem[Addr+2], Mem[Addr+1], Mem[Addr]}; // LW
               3'b100: Data_Out = {24'b0, Mem[Addr]}; // LBU
               3'b101: Data_Out = {16'b0, Mem[Addr+1], Mem[Addr]}; // LHU
         endcase 
      end
      else
         Data_Out = 32'b0;
   end
      
   initial begin 
   //   {Mem[3], Mem[2], Mem[1], Mem[0]} = 32'd24; 
   //   {Mem[7], Mem[6], Mem[5], Mem[4]} = 32'd2; 
   //   {Mem[11], Mem[10], Mem[9], Mem[8]} = 32'b10000010;
   //   {Mem[15], Mem[14], Mem[13], Mem[12]} = 32'b00000011; 
   end  

endmodule

