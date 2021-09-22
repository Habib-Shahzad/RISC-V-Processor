module registerFile(
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,  
  input [63:0] WriteData,
  output reg [63:0] ReadData1,
  output reg [63:0] ReadData2,
  input clk,
  input reset,
  input RegWrite
);
  reg [63:0] registers [31:0];
  int i;
  initial
    begin
      for (i = 0; i < 32; i+=1)
        begin
          registers[i] = 0;
        end
      registers[11] = 8;
    end
  
  always @ (*)
    begin
      if (reset == 1)
        begin
          ReadData1 = 64'b0;
          ReadData2 = 64'b0;
        end
      else
        begin
          ReadData1 = registers[rs1];
          ReadData2 = registers[rs2];
        end
    end
  always @ (posedge clk)
    begin
      if (RegWrite)
        begin
          registers[rd] = WriteData;
        end
    end
endmodule


