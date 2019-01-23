module Seg_Display
(
    CLK,
    DI,
    DO,
    SHF,
    DOT
);
    input CLK;
    input [31:0] DI;
    output reg [6:0] DO;
    output reg [7:0] SHF=8'b01111111;
    output reg DOT;

    reg [5:0] shr=0;

    wire [31:0] show_data;
    assign show_data[31:16]=DI[31:16];
    Time_BCD time_bcd(DI[15:0],show_data[15:0]);
    
    wire clk_t;
    Divider #(200000)divider(CLK,clk_t);
    always @(posedge clk_t) begin
        SHF<={SHF[6:0],SHF[7]};
        shr<=shr+4;
        if(SHF[1]==0) begin
            DOT<=0;
        end
        else begin
            DOT<=1;
        end
        case({show_data[shr+3],show_data[shr+2],show_data[shr+1],show_data[shr]})
            4'b0000: begin
                DO<=7'b1000000;
            end
            4'b0001: begin
                DO<=7'b1111001;
            end
            4'b0010: begin
                DO<=7'b0100100;
            end
            4'b0011: begin
                DO<=7'b0110000;
            end
            4'b0100: begin
                DO<=7'b0011001;
            end
            4'b0101: begin
                DO<=7'b0010010;
            end
            4'b0110: begin
                DO<=7'b0000010;
            end
            4'b0111: begin
                DO<=7'b1111000;
            end
            4'b1000: begin
                DO<=7'b0000000;
            end
            4'b1001: begin
                DO<=7'b0010000;
            end
            default: begin
                DO<=7'b1111111;
            end
        endcase
    end
    
endmodule