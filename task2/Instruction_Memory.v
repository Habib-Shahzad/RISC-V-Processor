module Instruction_Memory (
  input [63:0] Inst_Address,
  output reg [31:0] Instruction
); 
  
//add x25 x26 x27
//add x26 x20 x23
//add x23 x21 x27
//add x27 x22 x26
//         reg [7:0] memory [15:0];
//         initial begin
//          memory[15] = 8'b00000001;
//          memory[14] = 8'b10101011;
//          memory[13] = 8'b00001101;
//          memory[12] = 8'b10110011;

//          memory[11] = 8'b00000001;
//          memory[10] = 8'b10111010;
//          memory[9] = 8'b10001011;
//          memory[8] = 8'b10110011;

//          memory[7] = 8'b00000001;
//          memory[6] = 8'b01111010;
//          memory[5] = 8'b00001101;
//          memory[4] = 8'b00110011;

//          memory[3] = 8'b00000001;
//          memory[2] = 8'b10111101;
//          memory[1] = 8'b00001100;
//          memory[0] = 8'b10110011;

//         end
  
  
//add x25 x26 x27
//add x26 x25 x23
//add x23 x27 x26
//add x27 x23 x26
         reg [7:0] memory [15:0];
        initial begin
         memory[15] = 8'b00000001;
         memory[14] = 8'b10101011;
         memory[13] = 8'b10001101;
         memory[12] = 8'b10110011;

         memory[11] = 8'b00000001;
         memory[10] = 8'b10101101;
         memory[9] = 8'b10001011;
         memory[8] = 8'b10110011;

         memory[7] = 8'b00000001;
         memory[6] = 8'b01111100;
         memory[5] = 8'b10001101;
         memory[4] = 8'b00110011;

         memory[3] = 8'b00000001;
         memory[2] = 8'b10111101;
         memory[1] = 8'b00001100;
         memory[0] = 8'b10110011;

        end 
  
  
  always @(*)
    begin
      Instruction = {
        memory[Inst_Address+3],
        memory[Inst_Address+2], 
        memory[Inst_Address+1], 
        memory[Inst_Address+0] 
      };
    end
endmodule


