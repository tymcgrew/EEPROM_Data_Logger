module eeprom(clk, rst, sdata, sclk, done, adcclock, din, dout, cs);


	input clk, rst;
	output sclk, done;
	inout sdata;
	output adcclock, dout, cs;
	input din;
	
	wire [7:0]adc_out;
	
   wire pagewriter_done;
	wire [31:0]samplecounter;
	
	reg [14:0]address = 15'd2048;
	reg [511:0]write_data;
   reg [511:0]page_buffer;
	reg [31:0]prev_samplecounter;
   reg [31:0]page_counter;
   reg firstpass = 1'b1;
   reg done;
	reg enable;
	
	
	pagewriter pagewriter1(clk, rst, sdata, sclk, write_data, address, pagewriter_done, enable);
	adcreader adcreader1(clk, adcclock, din, dout, cs, rst, adc_out);
	samplecountertimer samplecountertimer1(clk, rst, samplecounter);
	
	
	always@(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			address <= 15'd2048;
			write_data <=  512'd0;
         page_buffer <= 512'd0;
			prev_samplecounter <= 32'd0;
         page_counter <= 32'd0;
			firstpass <= 1'b1;
         done <= 1'b0;
			enable <= 1'b0;
		end
		
		else
		begin
			if (page_counter < 32'd16)
         begin
				if (prev_samplecounter == samplecounter)
					enable <= 1'b0;
				prev_samplecounter <= samplecounter;
				if (samplecounter != prev_samplecounter)
				begin
					case(samplecounter)
						default: page_buffer[511:504] <= adc_out;
						32'd62:	page_buffer[503:496] <= adc_out;
						32'd61:	page_buffer[495:488] <= adc_out;
						32'd60:	page_buffer[487:480] <= adc_out;
						32'd59:	page_buffer[479:472] <= adc_out;
						32'd58:	page_buffer[471:464] <= adc_out;
						32'd57:	page_buffer[463:456] <= adc_out;
						32'd56:	page_buffer[455:448] <= adc_out;
						32'd55:	page_buffer[447:440] <= adc_out;
						32'd54:	page_buffer[439:432] <= adc_out;
						32'd53:	page_buffer[431:424] <= adc_out;
						32'd52:	page_buffer[423:416] <= adc_out;
						32'd51:	page_buffer[415:408] <= adc_out;
						32'd50:	page_buffer[407:400] <= adc_out;
						32'd49:	page_buffer[399:392] <= adc_out;
						32'd48:	page_buffer[391:384] <= adc_out;
						32'd47:	page_buffer[383:376] <= adc_out;
						32'd46:	page_buffer[375:368] <= adc_out;
						32'd45:	page_buffer[367:360] <= adc_out;
						32'd44:	page_buffer[359:352] <= adc_out;
						32'd43:	page_buffer[351:344] <= adc_out;
						32'd42:	page_buffer[343:336] <= adc_out;
						32'd41:	page_buffer[335:328] <= adc_out;
						32'd40:	page_buffer[327:320] <= adc_out;
						32'd39:	page_buffer[319:312] <= adc_out;
						32'd38:	page_buffer[311:304] <= adc_out;
						32'd37:	page_buffer[303:296] <= adc_out;
						32'd36:	page_buffer[295:288] <= adc_out;
						32'd35:	page_buffer[287:280] <= adc_out;
						32'd34:	page_buffer[279:272] <= adc_out;
						32'd33:	page_buffer[271:264] <= adc_out;
						32'd32:	page_buffer[263:256] <= adc_out;
						32'd31:	page_buffer[255:248] <= adc_out;
						32'd30:	page_buffer[247:240] <= adc_out;
						32'd29:	page_buffer[239:232] <= adc_out;
						32'd28:	page_buffer[231:224] <= adc_out;
						32'd27:	page_buffer[223:216] <= adc_out;
						32'd26:	page_buffer[215:208] <= adc_out;
						32'd25:	page_buffer[207:200] <= adc_out;
						32'd24:	page_buffer[199:192] <= adc_out;
						32'd23:	page_buffer[191:184] <= adc_out;
						32'd22:	page_buffer[183:176] <= adc_out;
						32'd21:	page_buffer[175:168] <= adc_out;
						32'd20:	page_buffer[167:160] <= adc_out;
						32'd19:	page_buffer[159:152] <= adc_out;
						32'd18:	page_buffer[151:144] <= adc_out;
						32'd17:	page_buffer[143:136] <= adc_out;
						32'd16:	page_buffer[135:128] <= adc_out;
						32'd15:	page_buffer[127:120] <= adc_out;
						32'd14:	page_buffer[119:112] <= adc_out;
						32'd13:	page_buffer[111:104] <= adc_out;
						32'd12:	page_buffer[103:96] <= adc_out;
						32'd11:	page_buffer[95:88] <= adc_out;
						32'd10:	page_buffer[87:80] <= adc_out;
						32'd9:	page_buffer[79:72] <= adc_out;
						32'd8:	page_buffer[71:64] <= adc_out;
						32'd7:	page_buffer[63:56] <= adc_out;
						32'd6:	page_buffer[55:48] <= adc_out;
						32'd5:	page_buffer[47:40] <= adc_out;
						32'd4:	page_buffer[39:32] <= adc_out;
						32'd3:	page_buffer[31:24] <= adc_out;
						32'd2:	page_buffer[23:16] <= adc_out;
						32'd1:	page_buffer[15:8] <= adc_out;
						32'd0:   page_buffer[7:0] <= adc_out;
					endcase
					
					case(samplecounter)
						32'd0:
						begin
							//if (firstpass == 1'b0)
							//begin
								write_data <= page_buffer;
								enable <= 1'b1;
							//end

						end
						32'd60:
						begin
							firstpass <= 1'b0;
							if (firstpass == 1'b0)
							begin
								page_counter <= page_counter + 32'd1;
								address <= address + 15'd64;
							end
						end
						default:
						begin
						end
					endcase	
				end
			end
			else
			begin
				 done <= 1'b1;
				 enable <= 1'b0;
			end
		end	
	end
	

endmodule 