module Data_Memory (
  input clk,
  input MemWrite,
  input [63:0] Mem_Addr,
  input MemRead,
  input [63:0] Write_Data,
  output reg [63:0] Read_Data
);
  
  reg [63:0] array [7:0];
  
  reg [7:0] memory [63:0];
  int i;

  initial begin
    for (i = 0; i<64; i = i+1)
      begin
        memory[i] = 0;
      end
//     memory[0] =  1;
//     memory[8] =  2;
//     memory[16] = 3;
//     memory[24] = 4;
//     memory[32] = 5;
//     memory[40] = 6;
//     memory[48] = 7;
//     memory[56] = 8;
  end
  
	int k;  
  always @(*) begin
  k = 0;
  for (i = 0; i < 8; i = i + 1)
    begin
      array[i] = {
        memory[k+7],
        memory[k+6],
        memory[k+5],
        memory[k+4],
        memory[k+3],
        memory[k+2],
        memory[k+1],
        memory[k+0]
      };
      k = k+8;
    end 
  end
  
//   always @(*) $display ("%p", array);
  
  always @(posedge clk)
    begin
      if (MemWrite == 1)
        begin
          memory[Mem_Addr+7] = Write_Data[63:56];
          memory[Mem_Addr+6] = Write_Data[55:48];
          memory[Mem_Addr+5] = Write_Data[47:40];
          memory[Mem_Addr+4] = Write_Data[39:32];
          memory[Mem_Addr+3] = Write_Data[31:24];
          memory[Mem_Addr+2] = Write_Data[23:16];
          memory[Mem_Addr+1] = Write_Data[15:8];
          memory[Mem_Addr+0] = Write_Data[7:0];
        end
    end
  always @(*)
    begin
      if (MemRead == 1)
        begin
          Read_Data = {
            memory[Mem_Addr+7],
            memory[Mem_Addr+6],
            memory[Mem_Addr+5],
            memory[Mem_Addr+4],
            memory[Mem_Addr+3],
            memory[Mem_Addr+2],
            memory[Mem_Addr+1],
            memory[Mem_Addr+0]
          };
        end
    end
 
endmodule


