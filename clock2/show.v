module show(clk,
		  showhour1, showhour0, showmin1, showmin0, showsec1, showsec0, 
		  ledhour1, ledhour0, ledmin1, ledmin0, ledsec1, ledsec0,
		  whichtoset, flashenable);
input clk, flashenable;
input [3:0] showhour1, showhour0, showmin1, showmin0, showsec1, showsec0;
input [2:0] whichtoset;
output wire [6:0] ledhour1, ledhour0, ledmin1, ledmin0, ledsec1, ledsec0;

reg flag;

wire settinghour, settingmin, settingsec;

assign {settinghour, settingmin, settingsec} = whichtoset;

display(showhour1, flag, settinghour, ledhour1);
display(showhour0, flag, settinghour, ledhour0);
display(showmin1, flag, settingmin, ledmin1);
display(showmin0, flag, settingmin, ledmin0);
display(showsec1, flag, settingsec, ledsec1);
display(showsec0, flag, settingsec, ledsec0);

always@(posedge clk)
begin
	if(flashenable)
		flag = 0;
	else
		flag = ~flag;
end
endmodule