module controlBranch (
  input branch,
  input zero,
  input less,
  input [2:0] funct,
  output reg branching,
  output reg flush
);

always @(*) 
  begin 
        case ({funct})
          	3'b000: branching = zero == 1; // beq
            3'b001: branching = !zero == 1; //bne
          	3'b100: branching = less  == 1; //blt
        endcase
    
    if (!branch) branching = 0;
    
  end
  
  always @(*)
    flush = branching ? 1:0;
  
endmodule








