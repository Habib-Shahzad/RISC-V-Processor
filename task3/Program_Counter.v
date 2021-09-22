module Program_Counter (
  input clk,
  input reset,
  input stall,
  input [63:0] PC_in,
  output reg [63:0] PC_out
);
  
  always @(posedge clk)
    begin
      if (reset)
        begin
          PC_out = 0;
          end
      else if (!stall)
        begin
          PC_out = PC_in;
          end
    end
  
endmodule


