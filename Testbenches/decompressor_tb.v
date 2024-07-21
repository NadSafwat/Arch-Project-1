`timescale 1ns / 1ps

/*******************************************************************
* Module: decompressor_tb.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: Gives the decompressor module decompressed instructions
		and tests that the module works correctly.
* Change history: 17/11/23 – Created module in lab
*******************************************************************************/

module decompressor_tb ();
    reg [15:0] compressedInstruction;
    wire [31:0] decompressedInstruction;

    decompressor decompressor (
        .compressedInstruction(compressedInstruction),
        .decompressedInstruction(decompressedInstruction)
        );

    initial begin

//        compressedInstruction = 16'b0000001001010001; // c.addi +
	
//        #10
//        compressedInstruction = 16'b0001001000110001; // c.addi -

//        #10
//        compressedInstruction = 16'b0000010000001110; // c.slli
        
//        #10
        
//        compressedInstruction = 16'b1000000001010001; // c.srli
        
//        #10
         
//        compressedInstruction = 16'b1000010001010001; // c.srai
        
//         #10
//        compressedInstruction = 16'b1000100100110001; // c.and i +
        
//        #10 
        
//        compressedInstruction = 16'b1001100101010001; // c.andi -
        
//         #10
//        compressedInstruction = 16'b1000001000011010; // c.mv
        
//         #10
//        compressedInstruction = 16'b1000110101110101; // c.and
	
//        compressedInstruction = 16'b1000111000110101; // c.xor
	
// #10
//        compressedInstruction = 16'b1000111001010101; // c.or
	
// #10
//        compressedInstruction = 16'b1000111110011001; // c.sub
	
// #10
//        compressedInstruction = 16'b1001000000000010; // c.ebreak
	
// #10
       compressedInstruction = 16'b1001001010100010; // c.add
	

        
	//compressedInstruction = 16'b0000100000000100;
	
	//#10

    end
    
endmodule
