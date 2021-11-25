module alarm_signal(clk1khz, on, cout);
input clk1khz, on;
output reg [7:0] cout;

parameter starlength = 200;
parameter spacelength = 100;
parameter longlength = 400;

reg[31:0] cnt_length;

always@(posedge clk1khz)
begin
	if(cnt_length == (starlength*5+spacelength*4+longlength-1))
		cnt_length <= 0;
	else
		cnt_length <= cnt_length + 1'b1;
end

always@(cnt_length)
begin
	if(on)
	begin
		if((cnt_length >= 0) && (cnt_length < starlength))
			cout <= 8'b11111111;
		else if((cnt_length >= starlength) && (cnt_length < (starlength + spacelength)))
			cout <= 8'b00000000;
		else if((cnt_length >= (starlength+spacelength)) && (cnt_length < (starlength*2+spacelength)))
			cout <= 8'b11111111;
		else if((cnt_length >= (starlength*2+spacelength)) && (cnt_length < (starlength*2+spacelength*2)))
			cout <= 8'b00000000;
		else if((cnt_length >= (starlength*2+spacelength*2)) && (cnt_length < (starlength*3+spacelength*2)))
			cout <= 8'b11111111;
		else if((cnt_length >= (starlength*3+spacelength*2)) && (cnt_length < (starlength*3+spacelength*3)))
			cout <= 8'b00000000;
		else if((cnt_length >= (starlength*3+spacelength*3)) && (cnt_length < (starlength*4+spacelength*3)))
			cout <= 8'b11111111;
		else if((cnt_length >= (starlength*4+spacelength*3)) && (cnt_length < (starlength*4+spacelength*4)))
			cout <= 8'b00000000;
		else if((cnt_length >= (starlength*4+spacelength*4)) && (cnt_length < (starlength*5+spacelength*4)))
			cout <= 8'b11111111;
		else
			cout <= 8'b00000000;
	end
	else
		cout <= 8'b00000000;
end
endmodule
