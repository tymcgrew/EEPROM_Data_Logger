module adcreader(clk, adcclock, din, dout, cs, rst, out);

	input clk, rst, din;
	output adcclock;
	output reg dout, cs;
	downclock downclock1(clk, adcclock, rst);
	output reg [7:0]out;

	
	reg [31:0]state;
	reg [7:0]buffer;
	
	always@(posedge adcclock or negedge rst)
	begin
	
		if (rst == 1'b0)
		begin
			dout <= 1'b0;
			cs <= 1'b1;		
			state <= 32'd0;
			buffer <= 8'd0;
			out <= 8'd0;
		end
		
		else
		begin
		
			state <= (state > 32'd12)? 32'd0 : state + 32'd1;
			
			case(state)
				32'd0:
				begin
					cs <= 1'b0;
					dout <= 1'b1;
					buffer <= 8'd0;
				end
				32'd1:
				begin
					cs <= 1'b0;
					dout <= 1'b0;
				end
				32'd2:
				begin
					cs <= 1'b0;
					dout <= 1'b0;
				end
				32'd3:
				begin
					cs <= 1'b0;
					dout <= 1'b1;
				end
				32'd4:
				begin

				end
				32'd5:
				begin
					buffer[7] <= din;
				end
				32'd6:
				begin
					buffer[6] <= din;
				end
				32'd7:
				begin
					buffer[5] <= din;
				end
				32'd8:
				begin
					buffer[4] <= din;
				end
				32'd9:
				begin
					buffer[3] <= din;
				end
				32'd10:
				begin
					buffer[2] <= din;
				end
				32'd11:
				begin
					buffer[1] <= din;
				end
				32'd12:
				begin
					buffer[0] <= din;
					cs <= 1'b1;
				end
				default:
				begin
					cs <= 1'b0;
					dout <= 1'b1;
					out <= buffer;
				end
			endcase	
		end
	end


endmodule