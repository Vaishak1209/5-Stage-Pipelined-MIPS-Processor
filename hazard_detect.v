`timescale 1ns / 1ps

module hazard_detect(
input [3:0]ID_RN1,
input [3:0]ID_RN2,
input [3:0]EX_WN,
input EX_MR,
output reg IFIDWrite,
output reg PCWrite,
output reg ST
    );
    
    always@(*) begin
        if(EX_MR && (EX_WN != 0) && ((ID_RN1 == EX_WN)||(ID_RN2 == EX_WN))) begin
            IFIDWrite = 1'b0;
            PCWrite = 1'b0;
            ST = 1'b1;
        end
        else begin
            IFIDWrite = 1'b1;
            PCWrite = 1'b1;
            ST = 1'b0;
        end
    end
endmodule
