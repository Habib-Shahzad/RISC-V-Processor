module threemux(
  input[63:0] a,
  input[63:0] b,
  input[63:0] c,
  input [1:0] S,
  output reg [63:0] out
);
  
  always @(*)
    begin
      case(S)
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
        default: out = 2'bX;
      endcase
    end

endmodule 

module mux (
  input [63:0] A,
  input [63:0] B,
  input S,
  output [63:0] Y   
);

assign Y = S ? B : A;


endmodule