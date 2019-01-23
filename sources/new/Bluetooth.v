module Bluetooth
(
	CLK,
	RST,

	UART_RXD,
	
    PREV,
    NEXT,
    UP,
    DOWN,
    
    RXD_DATA,
    SW
);

	input CLK;		
	input RST;		
	input UART_RXD;	

    output reg[2:0] PREV;
    output reg[2:0] NEXT;
    output reg UP;
    output reg DOWN;

    output [7:0]RXD_DATA;
    input [2:0]SW;

	wire clk_smp;
	Clk_Generator clk_generator(CLK,RST,clk_smp);

    wire[7:0]rxd_data;
    wire rxd_over;
    assign RXD_DATA=rxd_data;
	Uart_Receiver uart_receiver(CLK,clk_smp,RST,UART_RXD,rxd_over,rxd_data);

	always@(posedge CLK)begin
        case (rxd_data)
            8'h55:begin
                PREV <= 1;
            end 
            8'h5A:begin
                NEXT <= 1;
            end
            8'hA5:begin
                UP   <= 1;
            end
            8'hAA:begin
                DOWN <= 1;
            end
            8'h91:begin
                PREV<=SW;
                NEXT<=0;
            end
            8'h92:begin
                if(SW>=1)begin
                    PREV=SW-1;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=1-SW;
                end
            end
            8'h93:begin
                if(SW>=2)begin
                    PREV=SW-2;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=2-SW;
                end
            end
            8'h94:begin
                if(SW>=3)begin
                    PREV=SW-3;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=3-SW;
                end
            end
            8'h95:begin
                if(SW>=4)begin
                    PREV=SW-4;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=4-SW;
                end
            end
            8'h96:begin
                if(SW>=5)begin
                    PREV=SW-5;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=5-SW;
                end
            end
            8'h97:begin
                if(SW>=6)begin
                    PREV=SW-6;
                    NEXT<=0;
                end
                else begin
                    PREV<=0;
                    NEXT<=6-SW;
                end
            end
            default:begin
                PREV <= 0;
                NEXT <= 0;
                UP   <= 0;
                DOWN <= 0;
            end 
        endcase
    end

endmodule