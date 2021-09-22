module stallingUnit (
  input IDEXMemRead,
  input [4:0] IDEXrd,
  input [4:0] IFIDrs1,
  input [4:0] IFIDrs2,
  output reg stall
);

  always @(*)
    if (IDEXMemRead &&
    ((IDEXrd == IFIDrs1) |
     (IDEXrd == IFIDrs2)))
    stall = 1;
  else
    stall = 0;
endmodule