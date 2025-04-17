`timescale 1ns / 1ps

module alu(
input [31:0] data1,
input [31:0] data2,
input [1:0] ALUOp,
output zero,
output reg [31:0] alu_result
    );
    
    always@(*) begin
        case(ALUOp)
            2'b00: alu_result = data1 + data2;
            2'b01: alu_result = data1 - data2;
            2'b10: alu_result = data1 | data2;
            2'b11: alu_result = ~(data1 & data2);
            default: alu_result = 32'b0;
        endcase
    end
    
    assign zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;
    
endmodule
