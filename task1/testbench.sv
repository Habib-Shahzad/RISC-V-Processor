module tb;
  reg Clk;
  reg Reset;
  
  RISC_V_Processor test(
  .clk(Clk),
  .reset(Reset)
);  
  initial
    begin
      Reset = 1'b1;
      Clk = 1'b0;
      #10
      Reset = 1'b0;
    end
  
  always
    begin
      #5 Clk = ~Clk;
    end
  
    initial
      begin
        $dumpfile("dump.vcd");
        $dumpvars();
      end
  
endmodule

