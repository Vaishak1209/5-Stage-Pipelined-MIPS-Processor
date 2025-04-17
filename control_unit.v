`timescale 1ns / 1ps

module control_unit(
input [3:0] opcode,
input ST,
output reg ALUSrc,
output reg [1:0] ALUOp,
output reg MR,
output reg MW,
output reg MReg,
output reg EnIM,
output reg EnRW
    );
    
    always@(*) begin
        if(ST) begin
            begin ALUSrc = 1'b0; ALUOp = 2'b00; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b0; EnRW = 1'b0; end
        end
        else begin
            case(opcode)
                4'b0000: begin ALUSrc = 1'b1; ALUOp = 2'b00; MR = 1'b0; MW = 1'b1; MReg = 1'b0; EnIM = 1'b1; EnRW = 1'b0; end
                4'b0001: begin ALUSrc = 1'b0; ALUOp = 2'b00; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b1; EnRW = 1'b1; end
                4'b0011: begin ALUSrc = 1'b0; ALUOp = 2'b10; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b1; EnRW = 1'b1; end         
                4'b0111: begin ALUSrc = 1'b1; ALUOp = 2'b01; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b1; EnRW = 1'b1; end
                4'b1111: begin ALUSrc = 1'b0; ALUOp = 2'b11; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b1; EnRW = 1'b1; end
                default: begin ALUSrc = 1'b0; ALUOp = 2'b00; MR = 1'b0; MW = 1'b0; MReg = 1'b0; EnIM = 1'b0; EnRW = 1'b0; end
            endcase
        end
    end
endmodule
