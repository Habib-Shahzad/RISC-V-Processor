
module EXMEM(
  input clk,reset,
  input MemRead, 
  input memToReg, 
  input MemWrite,
  input regWrite, 
  input branch,
  input [63:0] WriteData, 
  input [63:0] add2, 
  input [4:0]  rd,
  input [63:0] AluResult,
  input zero,
  
  output reg MemWriteOut,
  output reg MemReadOut,
  output reg memToRegOut,
  output reg regWriteOut, 
  output reg branchOut, 
  output reg [63:0] WriteDataOut,
  output reg [63:0] add2Out,
  output reg [4:0] rdOut, 
  output reg [63:0] AluResultOut,
  output reg zeroOut
);
  
  always @(posedge clk )
    begin
      if (reset)
    begin
      MemWriteOut  = 0;
      MemReadOut   = 0;
      memToRegOut  = 0;
      regWriteOut  = 0;
      branchOut    = 0;
      WriteDataOut = 0;
      add2Out      = 0;
      rdOut        = 0;
      AluResultOut = 0;
      zeroOut      = 0;
    end        
      else
        begin
          MemReadOut   = MemRead;
          memToRegOut  = memToReg;
          MemWriteOut  = MemWrite;
          regWriteOut  = regWrite;
          branchOut    = branch;
          WriteDataOut = WriteData;
          add2Out      = add2;
          rdOut        = rd;
          AluResultOut = AluResult;
          zeroOut      = zero;
        end
    end
endmodule
