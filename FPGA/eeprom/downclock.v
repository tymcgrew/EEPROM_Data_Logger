module downclock(clk, adcclock, rst);

input clk, rst;
output reg adcclock;


reg [31:0]counter;
parameter threshold = 32'd128;     // 64
parameter half = 32'd64;          // 32

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		counter <= 32'd0;
		adcclock = 1'b0;
	end
	else
	begin
		if (counter >= threshold)
			counter <= 32'd0;
		else
			counter <= counter + 32'd1;
		adcclock = (counter > half)? 1'b1 : 1'b0;
	end
end
endmodule