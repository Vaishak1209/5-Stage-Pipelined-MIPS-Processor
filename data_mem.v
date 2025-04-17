`timescale 1ns / 1ps

module data_mem(
input clk,
input [31:0] addr,
input [31:0] write_data,
input MR, 
input MW,
output reg [31:0] read_data
    );
    
    reg [31:0] memory [0:15];
    
    genvar i;
    generate
        for(i=0;i<16;i=i+1) begin
            initial begin
                memory[i] = 32'b0;
            end
        end
    endgenerate
    
    always@(posedge clk) begin
        if(MR) begin
            read_data <= memory[addr];
        end
        if(MW) begin
            memory[addr] <= write_data;
        end
    end
endmodule
