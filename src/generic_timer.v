module timer
#(parameter final_value = 5)(
input clk,
input reset,
input enable,
input clear,
output done
);

localparam bit =  $clog2(final_value + 1) ;
reg [bit - 1 : 0]Q_reg, Q_next ;

always @(posedge clk , negedge reset)
  begin
    if(!reset)
      Q_reg = 'b0 ;
    else if(clear)
      Q_reg = 'b0 ;
    else if (~enable)
      Q_reg = Q_reg ;
    else
      Q_reg = Q_next ;
  end

assign done = (Q_reg == final_value) ;

always @(*)
  begin
    Q_next = done ? 'b0 : Q_reg +1 ;
  end

endmodule
