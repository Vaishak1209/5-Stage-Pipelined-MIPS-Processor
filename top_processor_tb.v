`timescale 1ns / 1ps

module top_processor_tb;

    reg clk;
    reg rst;
    
    top_processor uut(clk,rst);
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        rst = 1;
        #7;
        rst = 0;
        #103;
        $finish;
    end
endmodule
