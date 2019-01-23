module Uart_Receiver
(
	CLK,
	CLK_SMP,	
	RST_N,
	
	RXD,
	RXD_OVER,	
	RXD_DATA	
);

	input CLK;
	input CLK_SMP;	
	input RST_N;
	
	input RXD;
	output RXD_OVER;	
	output reg [7:0]RXD_DATA;	

	reg	rxd_sync_r0;
	reg rxd_sync_r1;				
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			rxd_sync_r0 <= 1;
			rxd_sync_r1 <= 1;
		end
		else if(CLK_SMP == 1) begin
			rxd_sync_r0 <= RXD;
			rxd_sync_r1 <= rxd_sync_r0;
		end
	end
	wire	rxd_sync = rxd_sync_r1;

	parameter R_IDLE   = 1'b0;		
	parameter R_SAMPLE = 1'b1;		
	reg	rxd_state;
	reg	[3:0] smp_cnt;					
	reg	[2:0] rxd_cnt;
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			smp_cnt <= 0;
			rxd_cnt <= 0;
			RXD_DATA <= 0;
			rxd_state <= R_IDLE;
		end
		else if(CLK_SMP == 1) begin
			case(rxd_state)
				R_IDLE:begin
					rxd_cnt <= 0;
					if(rxd_sync == 1'b0)begin
						smp_cnt <= smp_cnt + 1'b1;
						if(smp_cnt == 4'd7)		
							rxd_state <= R_SAMPLE;
					end
					else
						smp_cnt <= 0;
				end
		
				R_SAMPLE:begin
					smp_cnt <= smp_cnt +1'b1;
					if(smp_cnt == 4'd7) begin
						rxd_cnt <= rxd_cnt +1'b1;
						if(rxd_cnt == 4'd7)
							rxd_state <= R_IDLE;
						case(rxd_cnt)
							3'd0:	RXD_DATA[0] <= rxd_sync;
							3'd1:	RXD_DATA[1] <= rxd_sync;
							3'd2:	RXD_DATA[2] <= rxd_sync;
							3'd3:	RXD_DATA[3] <= rxd_sync;
							3'd4:	RXD_DATA[4] <= rxd_sync;
							3'd5:	RXD_DATA[5] <= rxd_sync;
							3'd6:	RXD_DATA[6] <= rxd_sync;
							3'd7:	RXD_DATA[7] <= rxd_sync;
						endcase
					end
				end
			endcase
		end
	end
	wire	rxd_flag_r = (rxd_cnt == 4'd7) ? 1'b1 : 1'b0;


	reg	rxd_flag_r0;
	reg rxd_flag_r1;
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			rxd_flag_r0 <= 0;
			rxd_flag_r1 <= 0;
		end
		else begin
			rxd_flag_r0 <= rxd_flag_r;
			rxd_flag_r1 <= rxd_flag_r0;
		end
	end
	assign	RXD_OVER = ~rxd_flag_r1 & rxd_flag_r0;

endmodule