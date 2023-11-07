`timescale 1ns / 1ps
/*******************************************************************
* Module: RCA.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module is a ripple carry adder that takes 2 n-bit
               inputs and outputs the sum and the carry. It also assigns
                the overflow and the carry flag.
* Change history: 12/09/23 – Created module in lab
                  03/11/23 - edited module to assien overflow and carry flags
*******************************************************************************/


module RCA #(parameter n=8)(
input [n-1:0] A, 
input [n-1:0] B,
output [n-1:0] P,
output carry,
output overflow
);

wire [n:0] C;
assign C[0] = 1'b0;
genvar i;

generate 
    for(i =0; i<n; i=i+1) begin
        full_adder FA(.A(A[i]), .B(B[i]), .cin(C[i]), .P(P[i]), .cout(C[i+1]));
    end
endgenerate 

assign carry = C[n];
assign overflow = (C[n] ^ C[n-1]);

endmodule
