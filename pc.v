`timescale 1ns / 1ps

module pc(
input clk, 
input [31:0] next_pc, 
input rst, 
input PCWrite,
output reg [31:0] pc
    );
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 32'b0;
        end
        else if (PCWrite) begin
            pc <= next_pc;
        end
    end
    
endmodule
