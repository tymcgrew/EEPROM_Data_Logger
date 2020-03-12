module pagewriter(clk, rst, sdata, sclk, write_data, address, done, enable);


//------------------------------------------------------------------
//                 -- Input/Output Declarations --                  
//------------------------------------------------------------------

input clk, rst;
output reg sclk;
inout reg sdata;

input [14:0]address;
input [511:0]write_data;

wire sclk_internal;
wire sdata_startcon,
	  sdata_stopcon,
	  sdata_writehigh,
	  sdata_writelow;

input enable;
output reg done;
	  

//------------------------------------------------------------------
//                  -- State & Reg Declarations  --                   
//------------------------------------------------------------------

parameter CONTROL = 3'd0,
          AHIGH = 3'd1,
          ALOW = 3'd2,
          DATA = 3'd3,
			 STOP = 3'd4,
			 WAIT = 3'd5;
			 
parameter LOW_THRESH  = 32'd3,       // 3
			 HIGH_THRESH = 32'd60;       // 30
			 
parameter SCLK_COUNTER_THRESH = 32'd128; // 64

reg [2:0]STATE, NEXT_STATE;
reg [31:0]counter;
reg [31:0]bit_counter;
reg [31:0]data_bit_counter;
reg secondpass;

downclock downclock1(clk, sclk_internal, rst);
startcon startcon1(clk, rst, sdata_startcon, counter);
stopcon stopcon1(clk, rst, sdata_stopcon, counter);
writehigh writehigh1(clk, rst, sdata_writehigh, counter);
writelow writelow1(clk, rst, sdata_writelow, counter);

//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------

always@(posedge clk or negedge rst)     // Determine STATE
begin

	if (rst == 1'b0)
		STATE <= DATA;
	else
		STATE <= NEXT_STATE;

end


always@(posedge clk or negedge rst)     // Determine outputs
begin

	if (rst == 1'b0)
	begin
		sclk <= 1'b0;
		counter <= 32'd0;
		bit_counter <= 32'd0;
		data_bit_counter <= 32'd0;
		sdata <= 1'bz;
		NEXT_STATE <= (enable == 1'b1)? CONTROL : WAIT;
		secondpass <= 1'b0;
		done <= 1'b0;
	end

	else
	begin
	
		sclk <= sclk_internal;
		counter <= (counter >= SCLK_COUNTER_THRESH)? 32'd0 : counter + 32'd1;
	
		case(STATE)

			CONTROL:
			begin
				case (bit_counter)
					32'd0:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_startcon : 1'bz;
						if (counter == LOW_THRESH)
							secondpass <= 1'b1;
						bit_counter <= (counter == LOW_THRESH && secondpass == 1'b1)? bit_counter + 32'd1 : bit_counter;
					end
					32'd1:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writehigh : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					32'd2:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end	
					32'd3:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writehigh : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd4:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd5:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd6:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd7:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd8:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd9:
					begin
						sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					default:
					begin
						NEXT_STATE <= AHIGH;
						bit_counter <= 32'd0;
					end
				endcase				
			end

			AHIGH:
			begin
				case (bit_counter)
					32'd0:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_writelow : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;
					end
					32'd1:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[14] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					32'd2:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[13] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end	
					3'd3:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[12] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd4:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[11] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					32'd5:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[10] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd6:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[9] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd7:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[8] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd8:
					begin
						sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					default:
					begin
						NEXT_STATE <= ALOW;
						bit_counter <= 32'd0;
					end
				endcase	
			end

			ALOW:
			begin
				case (bit_counter)
					32'd0:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[7] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;
					end
					32'd1:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[6] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					32'd2:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[5] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end	
					32'd3:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[4] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd4:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[3] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					32'd5:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[2] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd6:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[1] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd7:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (address[0] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;					
					end
					32'd8:
					begin
						sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;						
					end
					default:
					begin
						NEXT_STATE <= DATA;
						bit_counter <= 32'd0;
					end
				endcase
			end

			DATA:
			begin
				case (bit_counter)
					32'd0:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;
					end
					32'd1:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;				
					end
					32'd2:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;				
					end	
					32'd3:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;			
					end
					32'd4:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;				
					end
					32'd5:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;			
					end
					32'd6:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;				
					end
					32'd7:
					begin
						if (counter >= HIGH_THRESH || counter <= LOW_THRESH)
							sdata <= (write_data[data_bit_counter] == 1'b1)? sdata_writehigh : sdata_writelow;
						else 
							sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
						data_bit_counter <= (counter == LOW_THRESH)? data_bit_counter + 32'd1 : data_bit_counter;			
					end
					32'd8:
					begin
						sdata <= 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;	
					end
					default:
					begin
						if (data_bit_counter >= 32'd511)
						begin
							NEXT_STATE <= STOP;
							data_bit_counter <= 32'd0;
						end
						bit_counter <= 32'd0;
					end
				endcase
			end
			
			STOP:
			begin
				case(bit_counter)
					32'd0:
					begin
						sdata <= (counter >= HIGH_THRESH || counter <= LOW_THRESH)? sdata_stopcon : 1'bz;
						bit_counter <= (counter == LOW_THRESH)? bit_counter + 32'd1 : bit_counter;
					end
					default:
					begin
						bit_counter <= 32'd0;
						NEXT_STATE <= WAIT;
					end
				endcase
			end
			
			default: //WAIT
			begin
				if (enable == 1'b1)
				begin
					NEXT_STATE <= CONTROL;
					done <= 1'b0;
				end
				done <= 1'b1;
				sdata <= 1'bz;
			end

		endcase
	end

end


endmodule