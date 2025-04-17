`timescale 1ns / 1ps

module top_processor(
input clk,
input rst
    );
    //Initialisations for PC
    wire [31:0] pc,next_pc;
    wire PCWrite;
    //Initialisations for IM
    wire EnIM;
    wire [31:0] instr;
    wire [3:0] WN,RN1,RN2;
    wire [15:0] imm;
    //Initialisations for IF/ID register
    reg [63:0] IFIDReg;
    wire IFIDWrite;
    //Initialisations for control unit
    wire [3:0] opcode;
    wire ALUSrc, MR, MW, MReg, EnRW;
    wire [1:0] ALUOp;
    //Initialisations for register file
    wire [31:0] WB_write_data, data_read1, data_read2;
    wire [31:0] se_imm;
    wire WB_EnRW;
    wire [3:0] WB_rd;
    //Initialisations for hazard detection
    wire [3:0] ID_rs, ID_rt, EX_rd;
    wire EX_MR, ST;
    //Initialisations for ID/EX register
    reg [146:0] IDEXReg;
    wire [31:0] EX_PC, EX_data_read1, EX_data_read2, EX_imm;
    wire [3:0] EX_rs, EX_rt;
    wire [1:0] EX_ALUOp;
    wire EX_ALUSrc, EX_MW, EX_MReg, EX_EnRW;
    //Initialisations for forwarding unit 
    wire [3:0] MEM_rd;
    wire MEM_EnRW;
    wire [1:0] FA, FB;
    //Initialisations for ALU module
    wire [31:0] alu_in1, alu_src_mux, alu_in2, MEM_aluOut, alu_result;
    wire zero;
    //Initialisations for EX/MEM register
    reg [72:0] EXMEMReg;
    wire MEM_MR, MEM_MW, MEM_MReg, MEM_zero;
    wire [31:0] MEM_data_read2;
    //Initialisations for data memory
    wire [31:0] DM_out;
    //Initialisations for MEM/WB register
    reg [36:0] MEMWBReg;
    
    pc pc_inst(clk,next_pc,rst,PCWrite,pc);
    instr_mem im(clk,pc,EnIM,instr);
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            IFIDReg <= 64'b0;
        end
        else if (IFIDWrite) begin
            IFIDReg[63:32] <= instr;
            IFIDReg[31:0] <= pc;
        end
    end
    
    assign opcode = IFIDReg[63:60];
    assign WN = IFIDReg[59:56];
    assign RN1 = IFIDReg[55:52];
    assign RN2 = IFIDReg[51:48];
    assign imm = IFIDReg[47:32];
    
    control_unit cu(opcode, ST, ALUSrc, ALUOp, MR, MW, MReg, EnIM, EnRW);
    reg_file rf(clk,RN1,RN2,WB_write_data, WB_EnRW, WB_rd, data_read1, data_read2);
    sign_extend se(IFIDReg[47:32],se_imm);
    assign ID_rs = IFIDReg[55:52];
    assign ID_rt = IFIDReg[51:48];
    hazard_detect hd(ID_rs, ID_rt, EX_rd, EX_MR, IFIDWrite, PCWrite, ST);
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            IDEXReg <= 147'b0;
        end
        else begin
            IDEXReg[146:115] <= IFIDReg[31:0];
            IDEXReg[114:83] <= data_read1;
            IDEXReg[82:51] <= data_read2;
            IDEXReg[50:19] <= se_imm;
            IDEXReg[18:15] <= ID_rs;
            IDEXReg[14:11] <= ID_rt;
            IDEXReg[10:7] <= IFIDReg[59:56];
            IDEXReg[6:5] <= ALUOp;
            IDEXReg[4] <= ALUSrc;
            IDEXReg[3] <= MR;
            IDEXReg[2] <= MW;
            IDEXReg[1] <= MReg;
            IDEXReg[0] <= EnRW;
        end
    end
    assign EX_PC = IDEXReg[146:115];
    assign EX_data_read1 = IDEXReg[114:83];
    assign EX_data_read2 = IDEXReg[82:51];
    assign EX_imm = IDEXReg[50:19];
    assign EX_rs = IDEXReg[18:15];
    assign EX_rt = IDEXReg[14:11];
    assign EX_rd = IDEXReg[10:7];
    assign EX_ALUOp = IDEXReg[6:5];
    assign EX_ALUSrc = IDEXReg[4];
    assign EX_MR = IDEXReg[3];
    assign EX_MW = IDEXReg[2];
    assign EX_MReg = IDEXReg[1];
    assign EX_EnRW = IDEXReg[0];
    
    forwarding_unit fu(MEM_rd, EX_rs, EX_rt, WB_rd, MEM_EnRW, WB_EnRW, FA, FB);
    
    assign alu_in1 = (FA == 2'b00) ? EX_data_read1: (FA == 2'b10) ? MEM_aluOut : WB_write_data;
    assign alu_src_mux = (EX_ALUSrc) ? EX_imm : EX_data_read2;
    assign alu_in2 = (FB == 2'b00) ? alu_src_mux : (FB == 2'b10) ? MEM_aluOut : WB_write_data;
    
    alu alu(alu_in1, alu_in2, EX_ALUOp, zero, alu_result);
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            EXMEMReg <= 73'b0;
        end
        else begin
            EXMEMReg[72:41] <= alu_result;
            EXMEMReg[40:9] <= EX_data_read2;
            EXMEMReg[8:5] <= EX_rd;
            EXMEMReg[4] <= EX_MR;
            EXMEMReg[3] <= EX_MW;
            EXMEMReg[2] <= EX_MReg;
            EXMEMReg[1] <= EX_EnRW;
            EXMEMReg[0] <= zero;
        end
    end
    assign MEM_aluOut = EXMEMReg[72:41];
    assign MEM_data_read2 = EXMEMReg[40:9];
    assign MEM_rd = EXMEMReg[8:5];
    assign MEM_MR= EXMEMReg[4];
    assign MEM_MW = EXMEMReg[3];
    assign MEM_MReg= EXMEMReg[2];
    assign MEM_EnRW = EXMEMReg[1];
    assign MEM_zero = EXMEMReg[0];
    
    data_mem dm(clk, MEM_aluOut, MEM_data_read2, MEM_MR, MEM_MW, DM_out);
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            MEMWBReg <= 37'b0;
        end
        else begin
            MEMWBReg[36:5] <= (MEM_MReg) ? DM_out : MEM_aluOut;
            MEMWBReg[4:1] <= MEM_rd;
            MEMWBReg[0] <= MEM_EnRW;
        end
    end
    assign WB_write_data = MEMWBReg[36:5];
    assign WB_rd = MEMWBReg[4:1];
    assign WB_EnRW = MEMWBReg[0];
    
    assign next_pc = pc + 4;
endmodule