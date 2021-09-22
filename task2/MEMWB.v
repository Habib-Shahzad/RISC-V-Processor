module MEMWB (
  input clk,reset,
  input MemToReg, 
  input RegWrite,
  input [63:0] ReadData,
  input [63:0] AluResult,
  input [4:0] rd,
  
  output reg MemToRegOut, 
  output reg RegWriteOut, 
  output reg [63:0] ReadDataOut ,  
  output reg [63:0] AluResultOut, 
  output reg [4:0]rdOut
);
  
  always @(posedge clk)
    begin
      if (reset)
        begin
          MemToRegOut  = 0;
          RegWriteOut  = 0;
          ReadDataOut  = 0;
          AluResultOut = 0;
          rdOut        = 0;
        end
      else
        begin
          MemToRegOut  = MemToReg;
          RegWriteOut  = RegWrite;
          ReadDataOut  = ReadData;
          AluResultOut = AluResult;
          rdOut        = rd;
        end
    end
endmodule