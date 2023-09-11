module serial_register   
#(parameter N = 8)(
input clk ,
input enable ,
input reset_n ,
input msb ,
input load ,
input [N-1:0]data_in ,
output out ,
output [N-1:0]data_out
);

reg [N-1:0]Q_reg , Q_next ;

always @ (posedge clk , negedge reset_n)
begin
   if (~reset_n)
      Q_reg = 'b0  ;
   else if (~enable)
      Q_reg = Q_reg ;
   else
      Q_reg = Q_next ;
end

always @(*)
begin
  Q_next = Q_reg ;
  if (~load)
    Q_next = {msb , Q_reg [N-1 : 1]} ;
  else
    Q_next = data_in  ;
end

assign out = Q_reg[0] ;
assign data_out = Q_reg ;

endmodule
