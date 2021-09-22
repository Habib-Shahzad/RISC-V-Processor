// PIPELINE Processor

`include "ImmGen.v"
`include "Mux.v"
`include "InsParser.v"
`include "RegisterFile.v"
`include "ALU_64_bit.v"
`include "Data_Memory.v"
`include "Instruction_Memory.v"
`include "Program_Counter.v"
`include "Adder.v"
`include "ALU_Control.v"
`include "Control_Unit.v"

`include "IFID.v"
`include "IDEX.v"
`include "EXMEM.v"
`include "MEMWB.v"
`include "forwarding.v"


module RISC_V_Processor (
  input clk,
  input reset
);
  
  wire [63:0] PC_Out;
  wire [63:0] IFIDPC_Out;
  wire [63:0] IDEXPC_Out;
  
  wire [63:0] add_out1;
  wire [63:0] add_out2;
  wire [63:0] EXMEMadd_out2;
  
  wire [31:0] instruction;
  wire [31:0] IFIDinstruction;
  
  wire [63:0] imm_data;
  wire [63:0] IDEXimm_data;
  
  wire [63:0] ReadData;
  
  wire [63:0] Read_Data1;
  wire [63:0] IDEXRead_Data1;
  
  wire [63:0] Read_Data2;
  wire [63:0] IDEXRead_Data2;
  
  wire [3: 0] operation;
  
  wire [63:0] Result;
  wire [63:0] EXMEMResult;
  wire [63:0] MEMWBResult;
  
  wire [4:0] rd;
  wire [4:0] IDEXrd;
  wire [4:0] EXMEMrd;
  wire [4:0] MEMWBrd;
  
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [6:0] funct7;
  
  wire [4:0] rs1;
  wire [4:0] IDEXrs1;
  
  wire [4:0] rs2;
  wire [4:0] IDEXrs2;
  
  wire [3:0] IDEXfunct;
 
  wire branch;
  wire IDEXbranch;
  
  
  wire MemRead;
  wire IDEXMemRead;
  
  wire MemToReg;
  wire IDEXMemToReg;
  wire MEMWBMEMToReg;
 
  wire [1:0] ALUOp;
  wire [1:0] IDEXAluOp;
  
  wire MemWrite;
  wire IDEXMemWrite;
  
  wire ALUSrc;
  wire IDEXALUSrc;
  
  wire RegWrite;
  wire IDEXRegWrite;
  wire EXMEMRegWrite;
  wire MEMWBRegWrite;  
 
  wire [63:0] mux_out1;
  wire [63:0] MEMWBmux_out1;
  
  wire [63:0] mux_out2;
  wire [63:0] EXMEMmux_out2;
  wire [63:0] MEMWBmux_out2;
  
  wire [63:0] mux_out3;
  
  wire [63:0] threemux_out1;
  
  wire [63:0] threemux_out2;
  wire [63:0] EXMEMthreemux_out2;
  
  wire zero;
  wire EXMEMzero;
  
  wire [1:0] forwardA;
  wire [1:0] forwardB;

  Program_Counter pc (
    .PC_in(mux_out1),
    .clk(clk),
    .reset(reset),
    .PC_out(PC_Out)
  );
  
  Instruction_Memory im (
    .Inst_Address(PC_Out),
    .Instruction(instruction)
  );
  
  adder a1 (
    .a(PC_Out),
    .b(64'd4),
    .out(add_out1)
  );
  
  adder a2 (
    .a(IDEXPC_Out),
    .b(IDEXimm_data << 1),
    .out(add_out2)
  );
  
  IFID idif (
    .clk(clk),
    .reset(reset),
    
    .instructionIn(instruction),
    .addressIn(PC_Out),
    
    .instructionOut(IFIDinstruction),
    .addressOut(IFIDPC_Out)
  );
  
  instructionParser ip (
    .instruction(IFIDinstruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
  
  
  registerFile rf  (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(MEMWBrd),
    .WriteData(mux_out2),
    .RegWrite(MEMWBRegWrite),
    .ReadData1(Read_Data1),
    .ReadData2(Read_Data2)
  );
  

  
  IDEX  exid (
    .clk(clk),
    .reset(reset),
    
    .branch(branch),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemtoReg(MemToReg),
    .MemWrite(MemWrite), 
    .funct({IFIDinstruction[30],IFIDinstruction[14:12]}),
    .address(IFIDPC_Out),
    .ReadData1(Read_Data1),
    .ReadData2(Read_Data2),
    .imm_data(imm_data),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .AluOp(ALUOp),
    
    .branchOut(IDEXbranch),
    .MemReadOut(IDEXMemRead),
    .MemtoRegOut(IDEXMemToReg),
    .MemWriteOut(IDEXMemWrite),
    .RegWriteOut(IDEXRegWrite),
    .ALUSrcOut(IDEXAluSrc),
    .addressOut(IDEXPC_Out),
    .rs1Out(IDEXrs1),
    .rs2Out(IDEXrs2),
    .rdOut(IDEXrd),
    .imm_dataOut(IDEXimm_data),
    .ReadData1Out(IDEXRead_Data1),
    .ReadData2Out(IDEXRead_Data2),
    .functOut(IDEXfunct),
    .AluOpOut(IDEXAluOp)
  );
  
  
  Control_Unit cu (
    .opcode(opcode),
    .branch(branch),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)
  );
  
  
  ALU_64_bit alu64 (
    .a(threemux_out1),
    .b(mux_out3),
    .ALUOp(operation),
    .result(Result),
    .branching(zero),
    .operation(funct3[2])
  );
  
   
  ALU_Control ac (
    .ALUOp(IDEXAluOp),
    .Funct(IDEXfunct),
    .Operation(operation)
  );
  
  mux mu1 (
    .A(add_out1),
    .B(EXMEMadd_out2),
    .S(EXMEMzero & EXMEMbranch),
    .Y(mux_out1)
  );

   mux m2 (
     .A(MEMWBmux_out2),
     .B(MEMWBmux_out1),
     .S(MEMWBMemToReg),
     .Y(mux_out2)
  );
  
   mux m3(
    .A(threemux_out2),
    .B(IDEXimm_data),
    .S(IDEXAluSrc),
    .Y(mux_out3)
  );
  
  threemux m31 (
    .a(IDEXRead_Data1),
    .b(mux_out2),
    .c(EXMEMResult),
    .S(forwardA),
    .out(threemux_out1)
  );
  
  threemux m32( 
    .a(IDEXRead_Data2),
    .b(mux_out2),
    .c(EXMEMResult),
    .S(forwardB),
    .out(threemux_out2)
  );
  
  
   immediateGenerator ig (
    .instruction(IFIDinstruction),
    .imm_data(imm_data)
  );
  
  
  Data_Memory dm (
    .Write_Data(EXMEMmux_out2),
    .Mem_Addr(EXMEMResult),
    .MemWrite(EXMEMMemWrite),
    .clk(clk),
    .MemRead(EXMEMMemRead),
    .Read_Data(ReadData)
    
  );
  
  EXMEM memex(
    .clk(clk),
   .reset(reset),
   .add2(add_out2),
   .AluResult(Result),
   .zero(zero),
   .WriteData(threemux_out2),
   .rd(IDEXrd),
    .branch(IDEXbranch),
   .MemRead(IDEXMemRead),
   .memToReg(IDEXMemToReg),
   .MemWrite(IDEXMemWrite),
   .regWrite(IDEXRegWrite),
   
    .add2Out( EXMEMadd_out2),
   .zeroOut(EXMEMzero),
   .AluResultOut(EXMEMResult),
   .WriteDataOut(EXMEMmux_out2),
    .rdOut(EXMEMrd),
   .branchOut(EXMEMbranch),
   .MemReadOut(EXMEMMemRead),
   .memToRegOut(EXEMMEMMemToReg),
   .MemWriteOut(EXMEMMemWrite),
   .regWriteOut(EXMEMRegWrite)
  );
  
  
  MEMWB mwb (
    .clk(clk),
    .reset(reset),
    
    .ReadData(ReadData),
    .AluResult(EXMEMResult),
    .rd(EXMEMrd),
    .MemToReg(EXEMMEMMemToReg),
    .RegWrite(EXMEMRegWrite),
    
    .ReadDataOut(MEMWBmux_out1),
    .AluResultOut(MEMWBmux_out2),
    .rdOut(MEMWBrd),
    .MemToRegOut(MEMWBMemToReg),
    .RegWriteOut(MEMWBRegWrite)
  );
  
  forwardingUnit fu (
    .rs1(IDEXrs1),
    .rs2(IDEXrs2),
    .exRd(EXMEMrd),
    .wbRd(MEMWBrd),
    .wbRegWrite(MEMWBRegWrite),
    .exRegWrite(EXMEMRegWrite),
    .forwardA(forwardA),.forwardB(forwardB)
  );         
        
endmodule 