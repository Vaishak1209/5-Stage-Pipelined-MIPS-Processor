`timescale 1ns / 1ps

module reg_file(
input clk,
input [3:0] RN1,RN2,
input [31:0] WD,
input EnRW,
input [3:0] WN,
output [31:0] RD1,
output [31:0] RD2
    );
    genvar i;
    reg [31:0] registers [0:15];    
    
    generate
        for (i=0;i<16;i=i+1) begin
            initial begin
                registers[i] = 32'b0;
            end
        end
    endgenerate
    
    initial begin
        registers[1] <= 32'h0000AABB;
        registers[2] <= 32'h00000005;
        registers[4] <= 32'h00001034;
        registers[5] <= 32'h000BACC1;
        registers[7] <= 32'h000101ED;
    end

        assign RD1 = registers[RN1];
        assign RD2 = registers[RN2];
    
    always @(negedge clk) begin
        if ((EnRW)&&(WN != 0)) begin
            registers[WN] <= WD;
        end
    end
    
endmodule
