module control_unit (
input clk ,
input reset_n ,
input done ,
input change ,
input C_8 ,
output reset_all ,en_regA , en_regB , en_timer, load_B , load_A , finish
);

localparam s0 = 0 , s1 = 1 , s2 = 2 , s3 = 3 , s4 = 4 , s5 = 5 ;
reg [2:0]state ;
always @ (posedge clk , negedge reset_n)
begin
if (~reset_n)
  state = s0 ;
else if (change)
  state = s0 ;
else
  begin
    case(state)
      s0 : state <= s1 ;
      s1 : state <= s2 ;
      s2 : state <= done? s3 : s2 ;
      s3 : state <= C_8 ? s4 : s5 ;
      s4 : state <= s4 ;
      s5 : state <= s2 ;
      default : state <= s0 ;
    endcase
  end
end

assign reset_all = ~(state == s0) ;
assign load_A = (state == s1) ;
assign load_B = (state == s1 | state == s5) ;
assign en_regA = (state == s1 | state == s2) ;
assign en_regB = (state == s1 | state == s2 | state == s5) ;
assign en_timer = (state == s2) ;
assign finish = (state == s4) ;

endmodule
