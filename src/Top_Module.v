module sequential_8x8_multiplier (  
input clk ,
input reset_n ,
input [8:0]num_1 , num_2 ,
output reg[16:0] result
);

reg [7:0]num_1_pos , num_2_pos ;
reg [15:0] result_pos = 'bx ;

always@(num_1 , num_2 , result_pos)
begin
  case({num_1[8],num_2[8]})
    2'b00 : begin num_1_pos = num_1[7:0] ; num_2_pos = num_2[7:0] ; result = result_pos ; end
    2'b01 : begin num_1_pos = num_1[7:0] ; num_2_pos = -num_2[7:0] ; result = {1'b1,-result_pos} ; end
    2'b10 : begin num_1_pos = -num_1[7:0] ; num_2_pos = num_2[7:0] ; result = {1'b1,-result_pos} ; end
    2'b11 : begin num_1_pos = -num_1[7:0] ; num_2_pos = -num_2[7:0] ; result = result_pos ; end
    default : begin num_1_pos = num_1[7:0] ; num_2_pos = num_2[7:0] ; result = result_pos ; end
 endcase
end


wire s  , x , y  , D , Q_D , done ;
wire reset_all ,  C_8 , en_regA , en_regB , en_timer , load_A , load_B , finish ;
reg change = 1'b0 ;
wire [3:0]count ;
reg [15:0]data_in ;
wire [15:0]out_data ;


always @ (num_1 , num_2)
  begin
    change = 1'b1 ; 
    repeat(1) @(posedge clk) ;
    change = 1'b0 ; 
  end

assign C_8 = (count == 8) ;

always @(*)
  begin
    if (num_2_pos[count])
      data_in = num_1_pos << count  ;
    else
      data_in = 16'b0 ;
  end

always @(*) result_pos <= finish & ~change ? out_data : 'bx ;

  control_unit cu (
    .clk(clk),
    .reset_n(reset_n),
    .done(done),
    .change(change),
    .C_8(C_8) ,
    .reset_all(reset_all),
    .en_regA(en_regA),
    .en_regB(en_regB),
    .en_timer(en_timer),
    .load_A(load_A),
    .load_B(load_B),
    .finish(finish)
  );

  timer #(.final_value (15)) timer1 (
    .clk (clk),
    .reset(reset_all),
    .clear(),
    .enable(en_timer),
    .done(done)
  );  

  counter_4bit counter(
    .clk(clk),
    .reset_n(reset_all),
    .enable(done),
    .count(count)
  );  

  serial_register #(.N(16)) reg_A(
   .clk(clk),
   .enable(en_regA),
   .reset_n(reset_all),
   .msb(s),
   .load(load_A),
   .data_in('b0),
   .out(x),
   .data_out(out_data)
  );

  serial_register #(.N(16)) reg_B(
   .clk(clk),
   .enable(en_regB),
   .reset_n(reset_all),
   .msb(1'b0),
   .load(load_B),
   .data_in(data_in),
   .out(y),
   .data_out()
  );

  fulladder FA (
   .x(x),
   .y(y),
   .c_in(Q_D),
   .s(s),
   .c_out(D)
  );

  D_ff D_FF (
    .clk(clk),
    .reset_n(reset_all),
    .D(D),
    .Q_D(Q_D)
  );

endmodule
