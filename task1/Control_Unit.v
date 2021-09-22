module Control_Unit(  
  input [6:0] opcode,
  
  output reg branch,
  output reg MemRead,
  output reg MemToReg,
  output reg [1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite
);

  always @(opcode)
    begin
      case ( opcode )
        7'b0110011: // R
          begin
            ALUSrc   = 1'b0 ;
            MemToReg = 1'b0 ;
            RegWrite = 1'b1 ;
            MemRead  = 1'b0 ;
            MemWrite = 1'b0 ;
            branch   = 1'b0 ;
            ALUOp    = 2'b10;
          end
        7'b0000011: // I (ld)
          begin
            ALUSrc   = 1'b1 ;
            MemToReg = 1'b1 ;
            RegWrite = 1'b1 ;
            MemRead  = 1'b1 ;
            MemWrite = 1'b0 ;
            branch   = 1'b0 ;
            ALUOp    = 2'b00;
          end
        7'b0100011:  // I (sd)
          begin
            ALUSrc   = 1'b1 ;
            MemToReg = 1'bx ;
            RegWrite = 1'b0 ;
            MemRead  = 1'b0 ;
            MemWrite = 1'b1 ;
            branch   = 1'b0 ;
            ALUOp    = 2'b00;
          end
        7'b1100011:  // SB (beq)
          begin
            ALUSrc   = 1'b0 ;
            MemToReg = 1'bx ;
            RegWrite = 1'b0 ;
            MemRead  = 1'b0 ;
            MemWrite = 1'b0 ;
            branch   = 1'b1 ;
            ALUOp    = 2'b01;
          end
        7'b0010011: // I (addi)
          begin
            ALUSrc   = 1'b1 ;
            MemToReg = 1'b0 ;
            RegWrite = 1'b1 ;
            MemRead  = 1'b0 ;
            MemWrite = 1'b0 ;
            branch   = 1'b0 ;
            ALUOp    = 2'b10;
          end
        default:
          begin
            ALUSrc   = 1'b0 ;
            MemToReg = 1'b0 ;
            RegWrite = 1'b0 ;
            MemRead  = 1'b0 ;
            MemWrite = 1'b0 ;
            branch   = 1'b0 ;
            ALUOp    = 2'b0 ;
          end
      endcase
    end 
endmodule