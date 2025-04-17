This project contains a 5 stage pipelined MIPS processor, that can perform, R-type, I-type, and load-store type instructions. It also contains hazard detection and data forwarding units. The top module integrates all the main components of the processor - ALU, Data Memory, Instruction Memory, PC register, Control Unit, Hazard Detection, Forwarding Unit, Register File, and Sign Extend Unit.

The instructions loaded in the processor are:
0000 SW reg1, 3(reg2), 
0004 ADD reg3, reg1, reg4, 
0008 OR reg6, reg3, reg5, 
0012 SUBI reg8, reg3, 2400, 
0016 NAND reg9, reg7, reg8, 

where the opcodes for each instruction are:
Instruction 1: 0000, 
Instruction 2: 0001, 
Instruction 3: 0011, 
Instruction 4: 0111, 
Instruction 5: 1111

and the instruction format is as follows:
![image](https://github.com/user-attachments/assets/25064e8b-e729-4f97-99ff-1b914ce8a717)

