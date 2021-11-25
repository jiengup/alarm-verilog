module display(in, on, flash, out);

input on, flash;
input [3:0] in;
output reg [6:0] out;

always
begin
	if({on, flash} == 2'b11)
		out<= 7'b1111111;
	else
	begin
		case(in)
		0: out <= 7'b1000000;
		1: out <= 7'b1111001;
		2: out <= 7'b0100100;
		3: out <= 7'b0110000;
		4: out <= 7'b0011001;
		5: out <= 7'b0010010;
		6: out <= 7'b0000010;
		7: out <= 7'b1111000;
		8: out <= 7'b0000000;
		9: out <= 7'b0010000;
		15: out <= 7'b1111111;
		endcase
	end
end
endmodule
