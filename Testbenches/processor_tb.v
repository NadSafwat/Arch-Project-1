`timescale 1ns / 1ps

/*******************************************************************
* Module: processor_tb.v
* Project: Arch-Project-1
* Authors: Nadine Safwat nadine.hkm@aucegypt.edu
           Nour Kasaby N.Kasaby@aucegypt.edu
* Description: sets reset to 1 so that everything is initialized and then 
	       when rst is 0 the PC will increment as required 
* Change history: 17/11/23 – Created module in lab
*******************************************************************************/



module processor_tb();
    localparam clock_period = 10;
    reg clk;
    reg rst;

    processor p (.clk(clk), .rst(rst));
    
    initial begin 
        clk = 0;
        forever #(clock_period/2) clk = ~clk;
    end
    
    initial begin
        rst = 1;
        #(clock_period/2) 
 
        rst = 0;
    end
endmodule
