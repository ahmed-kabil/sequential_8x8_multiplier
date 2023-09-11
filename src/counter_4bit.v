module counter_4bit (     
input clk ,
input enable,
input reset_n,
output reg[3:0]count
);

always@(posedge clk , negedge reset_n)
  begin
    if (~reset_n)
      count = 4'b0 ;
    else if(enable)
      count = count + 1 ;
    else
      count = count ;
  end

endmodule
