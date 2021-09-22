module forwardingUnit (
    input [4:0] rs1,
    input [4:0] rs2,
    
    input [4:0] exRd, // EXMEM RD 
    input [4:0] wbRd,  //MEMWB RD
    
    input exRegWrite, //EXMEM REGWRITE
    input wbRegWrite, //MEMWB REGWRITE
    
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
 );
  
  always @(*)
    begin
      if ( (exRd == rs1) & (exRegWrite != 0 & exRd !=0))
          forwardA = 2'b10;
      else
        begin
          if (
            (wbRd == rs1) & 
            (wbRegWrite != 0 & wbRd != 0) & 
            ~((exRd == rs1) &(exRegWrite != 0 & exRd !=0)  )  
          )
              forwardA = 2'b01;
          else
              forwardA = 2'b00;
        end   
      if ( 
        (exRd == rs2) & 
        (exRegWrite != 0 & exRd !=0)
      )
        forwardB = 2'b10;        
      else    
          begin
            if ( 
              (wbRd == rs2) & 
              (wbRegWrite != 0 & wbRd != 0) &  
              ~((exRegWrite != 0 & exRd !=0 ) & 
                (exRd == rs2) ) 
            )
                forwardB = 2'b01;
            else
                forwardB = 2'b00;  
          end  
    end
endmodule