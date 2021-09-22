//BUBBLE SORT

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

module RISC_V_Processor (
  input clk,
  input reset
);
  wire [63:0] PC_Out;
  
  wire [63:0] add_out1;
  wire [63:0] add_out2;
  
  wire [31:0] instruction;
  wire [63:0] imm_data;
  
  wire [63:0] Read_Data;
  wire [63:0] Read_Data1;
  wire [63:0] Read_Data2;
  
  wire [3: 0] Operation;
  wire [63:0] Result;
  
  wire [6:0] opcode;
  wire [4:0] rd;
  wire [2:0] funct3;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [6:0] funct7;
  
  wire branch;
  wire MemRead;
  wire MemToReg;
  wire [1:0] ALUOp;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;  
  
  wire [63:0] mux_out1;
  wire [63:0] mux_out2;
  wire [63:0] mux_out3;
  
  wire branching;

  Program_Counter pc(
    .PC_in(mux_out1),
    .reset(reset),
    .clk(clk),
    .PC_out(PC_Out)
  );
 
  Instruction_Memory im(
    .Inst_Address(PC_Out),
    .Instruction(instruction)
  );
  
  adder a1(
    .a(PC_Out),
    .b(64'd4),
    .out(add_out1)
  );
  
  adder a2(
    .a(PC_Out),
    .b(imm_data << 1),
    .out(add_out2)
  );
  
  instructionParser ip(
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
  
  registerFile rf(
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(mux_out2),
    .RegWrite(RegWrite),
    .ReadData1(Read_Data1),
    .ReadData2(Read_Data2)
);
  
  Control_Unit cu(
    .opcode(opcode),
    .branch(branch),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
  );
  
  ALU_64_bit alu(
    .a(Read_Data1),
    .b(mux_out3),
    .ALUOp(Operation),
    .result(Result),
    .branching(branching),
    .operation(funct3[2])
  );
  
  ALU_Control aluc(
    .ALUOp(ALUOp),
    .Funct({instruction[30],instruction[14:12]}),
    .Operation(Operation)
  );
  
  mux m1(
    .A(add_out1),
    .B(add_out2),
    .S(branch & branching),
    .Y(mux_out1)
  );

  mux m2(
    .A(Result),
    .B(Read_Data),
    .S(MemToReg),
    .Y(mux_out2)
  );

  mux m3(
    .A(Read_Data2),
    .B(imm_data),
    .S(ALUSrc),
    .Y(mux_out3)
  );
    
  immediateGenerator ig(
    .instruction(instruction),
    .imm_data(imm_data)
  );
  
  Data_Memory dm(
    .clk(clk),
    .Mem_Addr(Result),
    .Write_Data(Read_Data2),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Read_Data(Read_Data)
  );
  
  
endmodule


