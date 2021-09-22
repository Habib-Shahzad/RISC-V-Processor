module IFID (
  input clk, reset,
  input [31:0]instructionIn,
  input [63:0] addressIn,
  
  output reg [31:0] instructionOut,
  output reg [63:0] addressOut
);
  
  always @(posedge clk)
    begin
      if (reset)
        begin
          instructionOut = 0;
          addressOut     = 0;
        end
      else
        begin
          instructionOut = instructionIn;
          addressOut     = addressIn;
        end
    end
  
endmodule