module ALU_64_bit (
  input [63:0]a,
  input [63:0]b,
  input [3:0] ALUOp,
  output reg [63:0]  result,
  input operation,
  output reg branching

);
  
  always @ (a or b or ALUOp)
    begin
      case (ALUOp)
        4'b0000: result = a & b;    // AND
        4'b0001: result = a | b;    // OR
        4'b0010: result = a + b;    // add
        4'b0110: result = a - b;    // sub
        4'b1100: result = ~(a | b); // NOR
      endcase
    end

  int bool;
  always@(*)
    begin
      case (operation)
        1'b0:    // beq
          begin
            branching = (result == 0) ? 1:0;
          end
        1'b1:   // blt
          begin
            bool = (a < b);
            branching = bool ? 1:0;
          end
        default: branching = 0;
      endcase 
    end
    
endmodule
