module original_to_1HZ(original_clk, clk1HZ);
input original_clk;
output reg clk1HZ;
reg[31:0] cnt_1HZ;
always@(posedge original_clk)
begin
	if(cnt_1HZ == 'd25000000-1)
	begin
		clk1HZ <= ~clk1HZ;
		cnt_1HZ <= 0;
	end
	else
	cnt_1HZ <= cnt_1HZ + 1'b1;
end
endmodule
