module decompressor_tb ();
    reg [15:0] compressedInstruction;
    wire [31:0] decompressedInstruction;

    decompressor decompressor (
        .compressedInstruction(compressedInstruction),
        .decompressedInstruction(decompressedInstruction)
        );

    initial begin
        $dumpfile("decompressor.vcd");         

        $dumpvars(0,decompressor_tb); 

        compressedInstruction = 16'b0000000000000001;
	
        #10
        compressedInstruction = 16'b0000010011000101;
	

        #10
	//compressedInstruction = 16'b0000100000000100;
	
	//#10
      

        $finish;

    end
    
endmodule