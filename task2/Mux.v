module mux(A, B, S, Y);
  
  output [63:0] Y; 
  input  S;
  input [63:0] A, B;
  
  assign Y = (S ? B:A);
  
endmodule

module threemux (
  input[63:0] a,
  input[63:0] b,
  input[63:0] c,
  input [1:0] S,
  output reg [63:0] out
);
  
  always @(*)
    begin
      case(S[1:0])
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
      endcase
    end
endmodule