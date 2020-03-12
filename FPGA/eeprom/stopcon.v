module stopcon(clk, rst, sdata, counter);

	input clk, rst;
	inout reg sdata;
	input [31:0]counter;

	always@(*)
	begin
		if (rst == 1'b0)
			sdata <= 1'bz;
		else
			 sdata = (counter < 32'd3 || counter >= 32'd100)? 1'b1 : 1'b0;
	end

endmodule