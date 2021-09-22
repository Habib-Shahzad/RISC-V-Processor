


module IFID (
  input clk, reset,
  input stall,
  input flush,
  input [31:0]instructionIn,
  input [63:0] addressIn,
  
  output reg [31:0] instructionOut,
  output reg [63:0] addressOut
);
  
  always @(posedge clk)
    begin
      if (reset | flush)
        begin
          instructionOut = 0;
          addressOut     = 0;
        end
      else if (!stall)
        begin
          instructionOut = instructionIn;
          addressOut     = addressIn;
        end
    end
  
endmodule