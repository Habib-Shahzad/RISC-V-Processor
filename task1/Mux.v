module mux(A, B, S, Y);
  
  output [63:0] Y; 
  input  S;
  input [63:0] A, B;
  
  assign Y = (S ? B:A);
  
endmodule