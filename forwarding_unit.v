`timescale 1ns / 1ps

module forwarding_unit(
input [3:0] MEM_WN, EX_RN1, EX_RN2, WB_WN,
input MEM_EnRW,
input WB_EnRW,
output reg [1:0] FA, FB
    );
    
    always@(*) begin
        if(MEM_EnRW && (MEM_WN != 0) && (MEM_WN == EX_RN1))begin
            FA = 2'b10;
        end
        else if(WB_EnRW && (WB_WN != 0) && (WB_WN == EX_RN1))begin
            FA = 2'b01;
        end
        else begin
            FA = 2'b00;
        end
        
        if (MEM_EnRW && (MEM_WN != 0) && (MEM_WN == EX_RN2))begin
            FB = 2'b10;
        end    
        else if(WB_EnRW && (WB_WN != 0) && (WB_WN == EX_RN2))begin
            FB = 2'b01;
        end
        else begin
            FB = 2'b00;
        end
    end
endmodule
