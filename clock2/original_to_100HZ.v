module original_to_100HZ(original_clk, clk100HZ);
input original_clk;
output reg clk100HZ;
reg[31:0] cnt_100HZ;
always@(posedge original_clk)
begin
	if(cnt_100HZ == 'd250000-1)
	begin
		clk100HZ <= ~clk100HZ;
		cnt_100HZ <= 0;
	end
	else
	cnt_100HZ <= cnt_100HZ + 1'b1;
end
endmodule
