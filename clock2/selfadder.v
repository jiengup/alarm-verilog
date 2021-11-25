module selfadder(clk, system, clocktime, cout, reset);
input clk, reset;
input [3:0] system;
output reg cout;
output reg [3:0] clocktime;

always@(posedge clk)
begin
	if(reset)
	begin
		clocktime <= 0;
		cout <= 0;
	end
	else
	begin
	if((clocktime == system) || (clocktime > system))
	begin
		clocktime <= 0;
		cout <= 1;
	end
	else
	begin
		clocktime <= clocktime + 1;
		cout <= 0;
	end
	end
end
endmodule
