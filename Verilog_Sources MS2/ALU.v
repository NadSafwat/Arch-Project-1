`timescale 1ns / 1ps

/*******************************************************************
* Module: ALU.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: recieves two imputs and according to the ALU_Sel will 
               choose the required operation to be applied on these 
               inputs and assign it to ALU_out. These two inputs are 
               also subtracted so that the flags can be determined.
* Change history: 26/09/23 – Created file in lab
                  03/11/23 – Added to case statment to include all 
                             instructions and added flags
**********************************************************************/

module ALU #(parameter n = 32)
(
    input [n-1:0] ALU_A,
    input [n-1:0] ALU_B,
    input [3:0] ALU_Sel,
    output Z_Flag,
    output V_Flag,
    output S_Flag,
    output C_Flag,
    output reg [n-1:0] ALU_out
);
    
    wire [n-1:0] ADD;
    wire [n-1:0] SUB;
    wire [n-1:0] Mux_Out;
    wire [n-1:0] Twos_Comp;

    assign Twos_Comp = (~ALU_B +1);
    assign Mux_Out = (ALU_Sel == 4'b0000) ? ALU_B : Twos_Comp;
    assign SUB = ADD;
    assign Z_Flag = (SUB == 0) ? 1'b1 : 1'b0;
    assign S_Flag = SUB[n-1];

    RCA RCA(.A(ALU_A), .B(Mux_Out), .Sum(ADD), .Carry_Out(C_Flag), .Overflow(V_Flag));
 
    always @ (*) begin
         case(ALU_Sel)
            4'b0000: ALU_out = ADD;
            4'b0001: ALU_out = SUB;
            4'b0011: ALU_out = ALU_B;
            4'b0100: ALU_out = ALU_A | ALU_B;
            4'b0101: ALU_out = ALU_A & ALU_B;
            4'b0111: ALU_out = ALU_A ^ ALU_B;
            4'b1000: ALU_out = ALU_A >> ALU_B;
            4'b1010: ALU_out = $signed(ALU_A) >>> ALU_B;
            4'b1001: ALU_out = ALU_A << ALU_B;
            4'b1101: ALU_out = (S_Flag != V_Flag) ?  32'b1 : 32'b0;
            4'b1111: ALU_out = (~C_Flag) ? 32'b1 : 32'b0;
            default: ALU_out = ALU_B;
         endcase
    end
endmodule