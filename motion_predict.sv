module motion_predict(
  input  logic Clk, Reset,
  input  logic motion_check,
  input logic [3:0] ut, dt, lt, rt, 
  output [3:0] data
);
parameter [2:0] up   = 2'b00;
parameter [2:0] down = 2'b01;
parameter [2:0] left = 2'b11;
parameter [2:0] right = 2'b10;
wire temp =  ~(out[3] ^ out[2]);
logic [3:0] out;
assign data = {out[3] ^ out[2], out[1] ^ out[0]};
always_ff @(posedge Clk or posedge Reset)
begin
  if (Reset) 
  begin
    out <= 2'b0000;
	end
  else 
  begin
    if(motion_check == 1'b1)
    begin
      out = {out[2:0],temp};    
    end
	end
end
endmodule