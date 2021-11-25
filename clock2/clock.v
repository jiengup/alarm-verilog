module clock(original_clk, clr, modeswitch, func, posswitch, changetime, ledhour1, ledhour0, ledmin1, ledmin0, ledsec1, ledsec0, signal_led, signal_led2);
(*chip_pin = "Y2"*)input original_clk;
(*chip_pin = "Y23"*)input clr;//SW17
(*chip_pin = "AA23"*)input func;
(*chip_pin = "Y24, AA22"*)input [1:0] modeswitch;
(*chip_pin = "N21"*)input posswitch;
(*chip_pin = "M21"*)input changetime;
(*chip_pin = "AA14, AG18, AF17, AH17, AG17, AE17, AD17"*)output [6:0] ledhour1;
(*chip_pin = "AC17, AA15, AB15, AB17, AA16, AB16, AA17"*)output [6:0] ledhour0;
(*chip_pin = "AH18, AF18, AG19, AH19, AB18, AC18, AD18"*)output [6:0] ledmin1;
(*chip_pin = "AE18, AF19, AE19, AH21, AG21, AA19, AB19"*)output [6:0] ledmin0;
(*chip_pin = "W28, W27, Y26, W26, Y25, AA26, AA25"*)output [6:0] ledsec1;
(*chip_pin = "U24, U23, W25, W22, W21, Y22, M24"*)output [6:0] ledsec0; 
(*chip_pin = "G21, G22, G20, H21, E24, E25, E22, E21"*)output [7:0] signal_led;
(*chip_pin = "H17, J16, H16, J15, G17, J17, H19, J19"*)output [7:0] signal_led2;
wire clk_1HZ;
wire clk_1kHZ;
wire clk_2HZ;
wire clk_100HZ;
wire [3:0] clockhour1, clockhour0, clockmin1, clockmin0, clocksec1, clocksec0;
wire [3:0] runmin1, runmin0, runsec1, runsec0, runms1, runms0;
wire[6:0] carryout;
wire[6:0] carryrun;
wire[3:0] hour0_system;

parameter
clock_mode = 2'b00,
set_mode = 2'b01,
alarm_mode = 2'b10,

noneset = 3'b000,
secset = 3'b001,
minset = 3'b010,
hourset = 3'b100;


reg[1:0] now_mode;
reg[3:0] showhour1, showhour0, showmin1, showmin0, showsec1, showsec0;
reg [3:0] alarmhour1, alarmhour0, alarmmin1, alarmmin0;
reg[2:0] setmode;
reg[2:0] alarmmode;
reg [2:0] whichtoset;
reg [6:0] carryclk;
reg alarmon;
reg clockon;

always@(modeswitch)
begin
now_mode = modeswitch;
end

assign hour0_system = (clockhour1 == 4'b0010) ? (4'b0011) : (4'b1001);

original_to_1HZ get1HZ(original_clk, clk_1HZ);//get 1HZ clock signal
original_to_2HZ get2HZ(original_clk, clk_2HZ);//get 1HZ clock signal
original_to_100HZ get100HZ(original_clk, clk_100HZ);//get 100HZ clock signal
original_to_1kHZ get1kHZ(original_clk, clk_1kHZ);//get 1kHZ clock signal


selfadder sec0(carryclk[0], 4'b1001, clocksec0, carryout[0], 0);
selfadder sec1(carryclk[1], 4'b0101, clocksec1, carryout[1], 0);
selfadder min0(carryclk[2], 4'b1001, clockmin0, carryout[2], 0);
selfadder min1(carryclk[3], 4'b0101, clockmin1, carryout[3], 0);
selfadder hour0(carryclk[4], hour0_system, clockhour0, carryout[4], 0);
selfadder hour1(carryclk[5], 4'b0010, clockhour1, carryout[5], 0);

selfadder run_ms0(clk_100HZ, 4'b1001, runms0, carryrun[0], clr);
selfadder run_ms1(carryrun[0], 4'b1001, runms1, carryrun[1], clr);
selfadder run_sec0(carryrun[1], 4'b1001, runsec0, carryrun[2], clr);
selfadder run_sec1(carryrun[2], 4'b0101, runsec1, carryrun[3], clr);
selfadder run_min0(carryrun[3], 4'b1001, runmin0, carryrun[4], clr);
selfadder run_min1(carryrun[4], 4'b1001, runmin1, carryrun[5], clr);

show(clk_2HZ,
	  showhour1, showhour0, showmin1, showmin0, showsec1, showsec0, 
	  ledhour1, ledhour0, ledmin1, ledmin0, ledsec1, ledsec0,
	  whichtoset, func);
alarm_signal alarmring(clk_1kHZ, alarmon, signal_led);
clock_signal clockring(clk_1kHZ, clockon, signal_led2);



always@(negedge posswitch)
begin
	case(setmode)
	noneset : setmode <= secset;
	secset : setmode <= minset;
	minset : setmode <= hourset;
	hourset : setmode <= secset;
	default : setmode <= noneset;
	endcase
end

always@(negedge posswitch)
begin
	case(alarmmode)
	noneset : alarmmode <= minset;
	minset : alarmmode <= hourset;
	hourset : alarmmode <= minset;
	default : alarmmode <= noneset;
	endcase
end

always
begin
	if(modeswitch == set_mode)
		whichtoset = setmode;
	else if(modeswitch == alarm_mode)
		whichtoset = alarmmode;
	else
		whichtoset = noneset;
end

always
begin
	if(modeswitch == set_mode)
	begin
	if(whichtoset == noneset)
		begin
			carryclk[0] = clk_1HZ;
			carryclk[1] = carryout[0];
			carryclk[2] = carryout[1];
			carryclk[3] = carryout[2];
			carryclk[4] = carryout[3];
			carryclk[5] = carryout[4];
		end
		else
		begin
		case(whichtoset)
		secset:
		begin
			carryclk[0] = (~changetime);
			carryclk[1] = carryout[0];
			carryclk[2] = carryout[1];
			carryclk[3] = carryout[2];
			carryclk[4] = carryout[3];
			carryclk[5] = carryout[4];
		end
		minset:
		begin
			carryclk[0] = 0;
			carryclk[1] = carryout[0];
			carryclk[2] = (carryout[1] | (~changetime));
			carryclk[3] = carryout[2];
			carryclk[4] = carryout[3];
			carryclk[5] = carryout[4];
		end
		hourset:
		begin
			carryclk[0] = 0;
			carryclk[1] = carryout[0];
			carryclk[2] = carryout[1];
			carryclk[3] = carryout[2];
			carryclk[4] = (carryout[3] | (~changetime));
			carryclk[5] = carryout[4];
		end
		endcase
		end
	end
	else
	begin
		carryclk[0] = clk_1HZ;
		carryclk[1] = carryout[0];
		carryclk[2] = carryout[1];
		carryclk[3] = carryout[2];
		carryclk[4] = carryout[3];
		carryclk[5] = carryout[4];
	end
end



always@(negedge changetime)
begin
	if(modeswitch == alarm_mode)
	begin
		if(whichtoset == minset)
		begin
			if({alarmmin1, alarmmin0} == 8'b01011001)
			begin
				alarmmin1 <= 4'b0000;
				alarmmin0 <= 4'b0000;
			end
			else if(alarmmin0 == 4'b1001)
			begin
				alarmmin0 <= 4'b0000;
				alarmmin1 <= (alarmmin1 + 1'b1);
			end
			else
				alarmmin0 <= (alarmmin0 + 1'b1);
		end
		else if(whichtoset == hourset)
		begin
			if({alarmhour1, alarmhour0} == 8'b00100011)
			begin
				alarmhour1 <= 4'b0000;
				alarmhour0 <= 4'b0000;
			end
			else if(alarmhour0 ==  4'b1001)
			begin
				alarmhour1 <= (alarmhour1 + 1'b1);
				alarmhour0 <= 4'b0000;
			end
			else
				alarmhour0 <= (alarmhour0 + 1'b1);
		end
		else
			alarmmin1 <= (alarmmin1 + 1'b1);
	end
end

always
begin
	if(now_mode == alarm_mode)
	begin
		if(func)
		begin
			showhour1 <= runmin1;
			showhour0 <= runmin0;
			showmin1 <= runsec1;
			showmin0 <= runsec0;
			showsec1 <= runms1;
			showsec0 <= runms0;
		end
		else
		begin
			showhour1 <= alarmhour1;
			showhour0 <= alarmhour0;
			showmin1 <= alarmmin1;
			showmin0 <= alarmmin0;
			showsec1 <= 4'b1111;
			showsec0 <= 4'b1111;
		end
	end
	else
	begin
		showhour1 <= clockhour1;
		showhour0 <= clockhour0;
		showmin1 <= clockmin1;
		showmin0 <= clockmin0;
		showsec1 <= clocksec1;
		showsec0 <= clocksec0;
	end
end

always
begin
	if(({clockhour1, clockhour0, clockmin1, clockmin0} == {alarmhour1, alarmhour0, alarmmin1, alarmmin0}) && (clocksec1 < 4'b0011) && ({clockhour1, clockhour0, clockmin1, clockmin0, clocksec1, clocksec0} != 18'b000000000000000000))
		alarmon = 1;
	else
		alarmon = 0;
end

always
begin
	if(({clockmin1, clockmin0} == 6'b000000) && (clocksec1 < 'd1))
		clockon = 1;
	else
		clockon = 0;
end
endmodule
