module Instruction_Memory (
  input [63:0] Inst_Address,
  output reg [31:0] Instruction
); 
  
reg [7:0] memory [71:0];
        initial begin
         memory[71] = 8'b11111100;
         memory[70] = 8'b00000000;
         memory[69] = 8'b00001010;
         memory[68] = 8'b11100011;

         memory[67] = 8'b00000001;
         memory[66] = 8'b11101010;
         memory[65] = 8'b10110000;
         memory[64] = 8'b00100011;

         memory[63] = 8'b00000000;
         memory[62] = 8'b11011011;
         memory[61] = 8'b00110000;
         memory[60] = 8'b00100011;

         memory[59] = 8'b00000000;
         memory[58] = 8'b11100000;
         memory[57] = 8'b00001111;
         memory[56] = 8'b00110011;

         memory[55] = 8'b11111100;
         memory[54] = 8'b00000000;
         memory[53] = 8'b00000110;
         memory[52] = 8'b11100011;

         memory[51] = 8'b00000000;
         memory[50] = 8'b01100000;
         memory[49] = 8'b00000010;
         memory[48] = 8'b10110011;

         memory[47] = 8'b00000000;
         memory[46] = 8'b10000011;
         memory[45] = 8'b00000011;
         memory[44] = 8'b00010011;

         memory[43] = 8'b00000000;
         memory[42] = 8'b00001101;
         memory[41] = 8'b10001110;
         memory[40] = 8'b00110011;

         memory[39] = 8'b00000000;
         memory[38] = 8'b00011101;
         memory[37] = 8'b10001101;
         memory[36] = 8'b10010011;

         memory[35] = 8'b11111110;
         memory[34] = 8'b10111110;
         memory[33] = 8'b01000010;
         memory[32] = 8'b11100011;

         memory[31] = 8'b00000000;
         memory[30] = 8'b10000010;
         memory[29] = 8'b10000010;
         memory[28] = 8'b10010011;

         memory[27] = 8'b00000000;
         memory[26] = 8'b00011110;
         memory[25] = 8'b00001110;
         memory[24] = 8'b00010011;

         memory[23] = 8'b00000010;
         memory[22] = 8'b11010111;
         memory[21] = 8'b01000010;
         memory[20] = 8'b01100011;

         memory[19] = 8'b00000000;
         memory[18] = 8'b00001011;
         memory[17] = 8'b00110111;
         memory[16] = 8'b00000011;

         memory[15] = 8'b00000000;
         memory[14] = 8'b00001010;
         memory[13] = 8'b10110110;
         memory[12] = 8'b10000011;

         memory[11] = 8'b00000000;
         memory[10] = 8'b01100101;
         memory[9] = 8'b00001011;
         memory[8] = 8'b00110011;

         memory[7] = 8'b00000000;
         memory[6] = 8'b01010101;
         memory[5] = 8'b00001010;
         memory[4] = 8'b10110011;

         memory[3] = 8'b00000100;
         memory[2] = 8'b10111101;
         memory[1] = 8'b10000100;
         memory[0] = 8'b01100011;

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


