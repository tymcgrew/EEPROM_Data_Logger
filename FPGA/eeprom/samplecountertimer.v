module samplecountertimer(clk, rst, samplecounter);

	input clk, rst;
	output reg [31:0]samplecounter;
	
	reg [31:0] counter;
	
	parameter THRESHOLD = 32'd8192;   //2^15 // 64 of these needs to be at least 7 milliseconds (8192), 128*64
	
	always@(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			counter <= 32'd0;
			samplecounter <= 32'd0;
		end
		else
		begin
			if (counter >= THRESHOLD)
			begin
				counter <= 32'd0;
				samplecounter <= (samplecounter >= 32'd63)? 32'd0 : samplecounter + 32'd1;
			end
			else
			begin
				counter <= counter + 32'd1;
			end
		end
	end
	
endmodule