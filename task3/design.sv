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
`include "stalling.v"
`include "flushing.v"


module RISC_V_Processor (
    input clk, reset
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
  wire [63:0] shiftedImm_data;
  assign shiftedImm_data = IDEXimm_data<< 1;

  wire [63:0] ReadData;
  wire [63:0] MEMWBReadData;
  
  wire [63:0] ReadData1;
  wire [63:0] IDEXRead_Data1;
  
  wire [63:0] ReadData2;
  wire [63:0] IDEXRead_Data2;
  wire [63:0] EXMEMReadData2;

  wire [3: 0] Operation;
  
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
  
  wire [3:0] IDEXfunct4;
  wire [3:0] EXMEMfunct4;
  wire [3:0] funct4;
  assign funct4 = {IFIDinstruction[30],IFIDinstruction[14:12]};

 
  wire branch;
  wire IDEXbranch;
  wire EXMEMbranch;
  wire andedBranch;
  
  wire MemRead;
  wire IDEXMemRead;
  
  wire MemToReg;
  wire IDEXMemToReg;
  wire MEMWBMEMToReg;
 
  wire [1:0] AluOp;
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
  
  wire zero, less;
  wire EXMEMzero, EXMEMless;
  
  wire [1:0] forwardA;
  wire [1:0] forwardB;

  
  wire stall;
  wire flush;
  
  wire [1:0] muxedAluOp;
  wire muxedMemToReg ;
  wire muxedRegWrite  ;
  wire muxedbranch  ;
  wire muxedMemWrite ;
  wire muxedMemRead ;
  wire muxedALUSrc;
  

    Program_Counter pc (
      .clk(clk),
      .reset(reset),
      .stall(stall),
      .PC_in(mux_out1),
      .PC_out(PC_Out)
    );


    immediateGenerator ig (
      .instruction(IFIDinstruction),
      .imm_data(imm_data)
    );
  
    Instruction_Memory im (
      .Inst_Address(PC_Out),
      .Instruction(instruction)
    );


    IFID idif (
      .clk(clk),
      .reset(reset),
      .flush(flush),

      .addressIn(PC_Out),
      .instructionIn(instruction),
      .stall(stall),

      .addressOut(IFIDPC_Out),
      .instructionOut(IFIDinstruction)
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
  

    registerFile rf (
      .clk(clk),
      .reset(reset),
      .rs1(rs1),
      .rs2(rs2),
      .RegWrite(MEMWBRegWrite),
      .WriteData(mux_out2),
      .rd(MEMWBrd),
      .ReadData1(ReadData1),
      .ReadData2(ReadData2)
    );


      Control_Unit cu (
        .opcode(opcode),
        .branch(branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(AluOp)
      );


    IDEX exid (
      .clk(clk),
      .reset(reset),
      .flush(flush),
      .RegWrite(muxedRegWrite),
      .MemtoReg(muxedMemToReg),
      .branch(muxedbranch),
      .MemWrite(muxedMemWrite),
      .MemRead(muxedMemRead),
      .address(IFIDPC_Out),
      .imm_data(imm_data),               
      .funct(funct4),
      .rd(rd),
      .rs1(rs1),
      .rs2(rs2),
      .ReadData1(ReadData1),
      .ReadData2(ReadData2),
      .ALUSrc(muxedALUSrc),
      .AluOp(muxedAluOp), 

      .addressOut(IDEXPC_Out),
      .ReadData1Out(IDEXRead_Data1),
      .ReadData2Out(IDEXRead_Data2),
      .imm_dataOut(IDEXimm_data),
      .functOut(IDEXfunct4),
      .rdOut(IDEXrd),
      .rs1Out(IDEXrs1),
      .rs2Out(IDEXrs2),
      .RegWriteOut(IDEXRegWrite),          
      .MemtoRegOut(IDEXMemToReg),
      .branchOut(IDEXbranch),
      .MemWriteOut(IDEXMemWrite),
      .MemReadOut(IDEXMemRead),
      .ALUSrcOut(IDEXAluSrc),
      .AluOpOut(IDEXAluOp)
    );



  ALU_Control ac (
    .ALUOp(IDEXAluOp),
    .Funct(IDEXfunct4),
    .Operation(Operation)
  );
  
      adder a1 (
      .a(PC_Out),
      .b(64'd4),
      .out(add_out1)
    );


    adder a2 (
      .a(IDEXPC_Out),
      .b(shiftedImm_data),
      .out(add_out2)
    );


    mux m1 (
      .A(add_out1),
      .B(EXMEMadd_out2),
      .S(branching),
      .Y(mux_out1)
    );


    mux m2 (
      .A(MEMWBResult),
      .B(MEMWBReadData),
      .S(MEMWBMemToReg),
      .Y(mux_out2)
    );


    mux m3 (
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

    threemux m32 (
      .a(IDEXRead_Data2),
      .b(mux_out2),
      .c(EXMEMResult),
      .S(forwardB),
      .out(threemux_out2)
    );


  ALU_64_bit alu64 (
    .a(threemux_out1),
    .b(mux_out3) ,
    .ALUOp(Operation),
    .result(Result),
    .zero(zero),
    .less(less)
  );



  EXMEM memex(
    .clk(clk),
    .reset(reset),
    .regWrite(IDEXRegWrite),
    .memToReg(IDEXMemToReg),
    .branch(IDEXbranch),
    .zero(zero),
    .less(less),
    .MemWrite(IDEXMemWrite),
    .MemRead(IDEXMemRead),
    .add2(add_out2),
    .AluResult(Result),
    .WriteData(threemux_out2),
    .funct(IDEXfunct4),
    .rd(IDEXrd),
    .flush(flush),

    .regWriteOut(EXMEMRegWrite),
    .memToRegOut(EXMEMMemToReg),
    .branchOut(EXMEMbranch),
    .zeroOut(EXMEMzero),
    .lessOut(EXMEMless),
    .MemWriteOut(EXMEMMemWrite),
    .MemReadOut(EXMEMMemRead),
    .add2Out(EXMEMadd_out2),
    .AluResultOut(EXMEMResult),
    .WriteDataOut(EXMEMReadData2),
    .functOut(EXMEMfunct4),
    .rdOut(EXMEMrd)
  );  

  Data_Memory dm (
    .clk(clk),
    .MemWrite(EXMEMMemWrite),
    .Mem_Addr(EXMEMResult),
    .Write_Data(EXMEMReadData2),
    .MemRead(EXMEMMemRead),
    .Read_Data(ReadData)
  );

  MEMWB wbmem (
  .clk(clk),
  .reset(reset),
  .RegWrite(EXMEMRegWrite),
  .MemToReg(EXMEMMemToReg),            
  .ReadData(ReadData),
  .AluResult(EXMEMResult),
  .rd(EXMEMrd),

  .RegWriteOut(MEMWBRegWrite),
  .MemToRegOut(MEMWBMemToReg),             
   .ReadDataOut(MEMWBReadData),
  .AluResultOut(MEMWBResult),
  .rdOut(MEMWBrd)
  );


  forwardingUnit fd (
    .exRd(EXMEMrd),
    .wbRd(MEMWBrd), 
    .rs1(IDEXrs1),
    .rs2(IDEXrs2),
    .exRegWrite(EXMEMRegWrite),
    .wbRegWrite(MEMWBRegWrite),
    .forwardA(forwardA),
    .forwardB(forwardB)
  );

      controlBranch cbb (
      EXMEMbranch,
      EXMEMzero,
      EXMEMless,
      EXMEMfunct4[2:0],
      branching,
      flush
    );

    stallingUnit su (
        .IDEXMemRead(IDEXMemRead),
        .IDEXrd(IDEXrd),
        .IFIDrs1(rs1),
        .IFIDrs2(rs2),
        .stall(stall)
    );

    assign muxedMemToReg = stall ? 0 : MemToReg ;
    assign muxedRegWrite = stall ? 0 : RegWrite ;
    assign muxedbranch   = stall ? 0 : branch   ;
    assign muxedMemWrite = stall ? 0 : MemWrite ;
    assign muxedMemRead  = stall ? 0 : MemRead  ;
    assign muxedALUSrc   = stall ? 0 : ALUSrc   ;
    assign muxedAluOp    = stall ? 0 : AluOp    ;

  endmodule


