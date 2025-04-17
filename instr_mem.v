`timescale 1ns / 1ps

module instr_mem(
input clk,
input [31:0] addr,
input EnIM,
output reg [31:0] instr
    );
    
    always@(posedge clk) begin
        if(EnIM)begin 
            case(addr)
                32'd0: instr <= 32'b00000001001000010000000000000011;
                32'd4: instr <= 32'b00010011000101000000000000000000;
                32'd8: instr <= 32'b00110110001101010000000000000000;
                32'd12: instr <= 32'b01111000001100000010010000000000;
                32'd16: instr <= 32'b11111001011110000000000000000000;
                default: instr <= 32'b0;
            endcase
        end
        else begin
            instr <= 32'b0;
        end
    end
    
endmodule
