module original_to_1kHZ(original_clk, clk1kHZ);
input original_clk;
output reg clk1kHZ;
reg[25:0] cnt_1kHZ;
always@(posedge original_clk)
begin
	if(cnt_1kHZ == 'd25000-1)
	begin
		cnt_1kHZ <= 0;
		clk1kHZ <= ~clk1kHZ;
	end
	else
		cnt_1kHZ <= cnt_1kHZ + 1'b1;
end
endmodule