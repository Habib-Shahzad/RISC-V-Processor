

module ALU_64_bit (
	input [63:0] a,
	input [63:0] b,
  input [3:0] ALUOp,
  output reg [63:0] result,
	output reg zero,
    output reg less
);

  always @ (a or b or ALUOp)
    begin
      case (ALUOp)
        4'b0000: result = a & b;    // AND
        4'b0001: result = a | b;    // OR
        4'b0010: result = a + b;    // add
        4'b0110: result = a - b;    // sub
        4'b1100: result = ~(a | b); // NOR
        4'b1111: result = a << b;  // slli
      endcase
    end
  
  always @(*) begin
	zero = a == b;
    less = (a < b);
  end

endmodule