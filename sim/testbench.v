module sequential_8x8_multiplier_tb ( );
reg clk ;
reg reset_n ;
reg [8:0]num_1 , num_2 ;
wire [16:0] result ;

sequential_8x8_multiplier UUT (
  .clk(clk),
  .reset_n(reset_n),
  .num_1(num_1),
  .num_2(num_2),
  .result(result)
);

always
begin
  clk = 1'b0 ; #10 
  clk = 1'b1 ; #10 ;
end

initial
begin
    reset_n = 1'b1 ;
    num_1 = 8'd241 ; num_2 = 8'd187 ;
  repeat(150) @(posedge clk) ;
    reset_n = 1'b0 ;
  repeat(10) @(negedge clk) ;
    reset_n = 1'b1 ;
    num_1 = -8'd151 ; num_2 = 8'd67 ;
  #3000 ;
    num_1 = 8'd220 ; num_2 = -8'd173 ;
  repeat(150) @(negedge clk) ;
    num_1 = -8'd82 ; num_2 = -8'd124 ;
  repeat(150) @(negedge clk) ;
    num_1 = 8'd222 ; num_2 = 8'd232 ;
  repeat(150) @(negedge clk) ;
  $stop ;
end

endmodule 
