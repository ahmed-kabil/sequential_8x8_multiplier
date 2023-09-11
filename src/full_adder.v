module fulladder (  
input x , y , c_in ,
output reg s , c_out
);

always @ (*)
  begin 
    {c_out , s} = x + y + c_in  ;
  end
endmodule
