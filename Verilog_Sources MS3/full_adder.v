`timescale 1ns / 1ps
/*******************************************************************
* Module: full_adder.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: This module is a full adder that takes 3 inputs, carries
               out addition and then and outputs the sum and the carry
* Change history: 26/09/23 – Created module in lab
**********************************************************************/


module full_adder(
    input A,
    input B,
    input cin,
    output P,
    output cout
    );

assign {cout,P} = A + B + cin;

endmodule
