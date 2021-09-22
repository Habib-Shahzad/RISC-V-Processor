module immediateGenerator(
  input [31:0] instruction,
  output reg[63:0] imm_data
);
  
  wire [6:0] opcode;
	assign opcode = instruction[6:0];

    always @ (*)
    begin
      case ( opcode[6:5] )
        
        2'b00: imm_data[11:0] = {instruction[31:20]} ;
         
        2'b01:imm_data[11:0] = {instruction[31:25], instruction[11:7] } ;
        
        2'b11: imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]  } ;
                                                                                            
        default: imm_data[11:0] = 12'b0;
      endcase
      
      imm_data = { {52 { imm_data[11] } } , imm_data[11:0] } ;
    end  
endmodule
