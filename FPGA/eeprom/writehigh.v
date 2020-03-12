module writehigh(clk, rst, sdata, counter);

	input clk, rst;
	inout sdata;
	input [31:0]counter;

	assign sdata = (rst == 1'b1)? 1'bz : 1'b1;

endmodule