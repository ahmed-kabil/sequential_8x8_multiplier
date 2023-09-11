module D_ff (
input clk ,
input reset_n ,
input D ,
output reg Q_D
);

always @(posedge clk , negedge reset_n)
  begin
   if (~reset_n)
     Q_D = 1'b0 ;
   else
     Q_D = D ;
  end

endmodule
