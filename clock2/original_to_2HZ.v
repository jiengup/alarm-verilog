module original_to_2HZ(original_clk, clk2HZ);
input original_clk;
output reg clk2HZ;
reg[31:0] cnt_2HZ;
always@(posedge original_clk)
begin
	if(cnt_2HZ == 'd12500000-1)
	begin
		clk2HZ <= ~clk2HZ;
		cnt_2HZ <= 0;
	end
	else
	cnt_2HZ <= cnt_2HZ + 1'b1;
end
endmodule
