module IDEX (
  input clk,reset,
  input MemRead, 
  input MemtoReg, 
  input MemWrite, 
  input ALUSrc, 
  input RegWrite,
  input branch,
  input [63:0] ReadData1,
  input [63:0] ReadData2,
  input [63:0] imm_data,
  input [63:0] address,
  input [3:0] funct,
  input [4:0] rd,
  input [4:0] rs1,
  input [4:0] rs2,
  input [1:0] AluOp,
  
  output reg MemReadOut,
  output reg MemtoRegOut,
  output reg MemWriteOut,
  output reg ALUSrcOut,
  output reg RegWriteOut,
  output reg branchOut,
  output reg [63:0] ReadData1Out,
  output reg [63:0] ReadData2Out, 
  output reg [63:0] imm_dataOut,
  output reg [63:0] addressOut,
  output reg [3:0] functOut,
  output reg [4:0] rdOut,
  output reg [4:0] rs1Out,
  output reg [4:0] rs2Out,
  output reg [1:0] AluOpOut
);
  
  always @(posedge clk )
    begin
    if (reset)
      begin
        MemReadOut   = 0;
        MemtoRegOut  = 0;
        MemWriteOut  = 0;
        ALUSrcOut    = 0;
        RegWriteOut  = 0;
        branchOut    = 0;
        ReadData1Out = 0;
        ReadData2Out = 0;
        imm_dataOut  = 0;
        addressOut   = 0;
        functOut     = 0;
        rdOut        = 0;
      	rs1Out       = 0;
      	rs2Out       = 0;
        AluOpOut     = 0;
    end
      else
        begin
        MemReadOut   = MemRead;
       	MemtoRegOut  = MemtoReg;
        MemWriteOut  = MemWrite;
        ALUSrcOut    = ALUSrc;
		RegWriteOut  = RegWrite;
		branchOut    = branch;
		ReadData1Out = ReadData1;
		ReadData2Out = ReadData2;
		imm_dataOut  = imm_data;
		addressOut   = address;
		functOut     = funct;
		rdOut        = rd;
		rs1Out       = rs1;
		rs2Out       = rs2;
        AluOpOut     = AluOp;
        end
    end
endmodule