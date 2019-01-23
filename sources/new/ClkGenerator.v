module Clk_Generator
(
	CLK,
	RST_N,
	CLK_SMP
);
	input	CLK;
	input	RST_N;
	output	CLK_SMP;

    wire clk_bps;

	reg	[31:0]	bps_cnt1;
	reg	[31:0]	bps_cnt2;
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			bps_cnt1 <= 0;
			bps_cnt2 <= 0;
		end
		else begin
			bps_cnt1 <= bps_cnt1 + 32'd412317;		
			bps_cnt2 <= bps_cnt2 + 32'd6597070;
		end
	end

	reg	clk_bps_r0;
	reg clk_bps_r1;
	reg clk_bps_r2;
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			clk_bps_r0 <= 0;
			clk_bps_r1 <= 0;
			clk_bps_r2 <= 0;
		end
		else begin
			if(bps_cnt1 < 32'h7FFF_FFFF) begin
				clk_bps_r0 <= 0;
			end
			else begin
				clk_bps_r0 <= 1;
			end
			clk_bps_r1 <= clk_bps_r0;
			clk_bps_r2 <= clk_bps_r1;
		end
	end
	assign	clk_bps = ~clk_bps_r2 & clk_bps_r1;

	reg	clk_smp_r0;
	reg clk_smp_r1;
	reg clk_smp_r2;
	always@(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			clk_smp_r0 <= 0;
			clk_smp_r1 <= 0;
			clk_smp_r2 <= 0;
		end
		else begin
			if(bps_cnt2 < 32'h7FFF_FFFF) begin
				clk_smp_r0 <= 0;
			end
			else begin
				clk_smp_r0 <= 1;
			end
			clk_smp_r1 <= clk_smp_r0;
			clk_smp_r2 <= clk_smp_r1;
		end
	end
	assign	CLK_SMP = ~clk_smp_r2 & clk_smp_r1;

endmodule