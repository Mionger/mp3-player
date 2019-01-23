module MP3
(
    CLK,

    RST,

    MP3_RSET,
    MP3_CS,
    MP3_DCS,

    MP3_MOSI,
    MP3_MISO,
    MP3_SCLK,
    MP3_DREQ,
    
    ROTATION_SW,
    ROTATION_SIA,
    ROTATION_SIB,

    UART_RXD,

    SEG_DISPLAY_DOT,
    SEG_DISPLAY_SHF,
    SEG_DISPLAY_DO,

    LED
);
    input CLK;

    input RST;

    output reg MP3_RSET=1;
    output reg MP3_CS=1;
    output reg MP3_DCS=1;
    output reg MP3_MOSI=0;
    input MP3_MISO;
    output reg MP3_SCLK=0;
    input MP3_DREQ;

    input ROTATION_SW;
    input ROTATION_SIA;
    input ROTATION_SIB;

    input UART_RXD;

    output SEG_DISPLAY_DOT;
    output [7:0] SEG_DISPLAY_SHF;
    output [6:0] SEG_DISPLAY_DO;

    output [15:0] LED;
    
   
    
    //分频
    wire clk;
    Divider #(100) divider(CLK,clk);

    //命令
    integer cnt=0;
    integer cmd_cnt=0;
    parameter cmd_cnt_max=4;
    reg [31:0] next_cmd;
    reg [127:0] cmd_init={32'h02000804,32'h02000804,32'h020B0000,32'h020000800};
    reg [127:0] cmd={32'h02000804,32'h02000804,32'h020B0000,32'h020000800};
    
    //时间显示
    wire [2:0] sw;
    wire [15:0] time_sec;
    Time_Cnt time_cnt(clk,pos[14:0]==0,time_sec);
    Seg_Display seg_display(CLK,{13'b0,sw[2:0],time_sec[15:0]},SEG_DISPLAY_DO,SEG_DISPLAY_SHF,SEG_DISPLAY_DOT);
    
    //蓝牙
    wire [2:0]bluetooth_prev;
    wire [2:0]bluetooth_next;
    wire bluetooth_up;
    wire bluetooth_down;
    wire [7:0]rxd_data;
    wire uart_rxd;
    Bluetooth bluetooth(CLK,RST,UART_RXD,bluetooth_prev,bluetooth_next,bluetooth_up,bluetooth_down,rxd_data,sw);//
    
    //音量
    wire [15:0] vol;
    wire [1:0]dir;
    wire [15:0]vol_de;
    Rotation rotation(clk,ROTATION_SIA,ROTATION_SIB,ROTATION_SW,dir);

    wire up;
    wire down;
    assign up  = bluetooth_up   | dir[1];
    assign down= bluetooth_down | dir[0];
    Vol_Set vol_set(clk,up,down,vol);
    Vol_Decoder vol_decoder(vol,vol_de);
    assign LED=vol_de;
    
    //切换
    reg [2:0] pre_sw=0;
    wire [2:0]prev;
    wire [2:0]next;
    assign prev=bluetooth_prev;
    assign next=bluetooth_next;
    SW_Set sw_set(clk,prev,next,sw);
    
    //读取数据
    wire [15:0] data0;
    wire [15:0] data1;
    wire [15:0] data2;
    wire [15:0] data3;
    wire [15:0] data4;
    wire [15:0] data5;
    wire [15:0] data6;
    reg [15:0] data;
    reg [20:0] pos=0;
    blk_mem_gen_0 music_0(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data0));
    blk_mem_gen_1 music_1(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data1));
    blk_mem_gen_2 music_2(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data2));
    blk_mem_gen_3 music_3(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data3));
    blk_mem_gen_4 music_4(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data4));
    blk_mem_gen_5 music_5(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data5));
    blk_mem_gen_6 music_6(.clka(CLK),.wea(0),.addra(pos[12:0]),.dina(0),.douta(data6));

    parameter INITIALIZE = 3'd0;
    parameter SEND_CMD = 3'd1;
    parameter CHECK = 3'd2;
    parameter DATA_SEND = 3'd3;
    parameter RSET_OVER = 3'd4;
    parameter VOL_SET_PRE = 3'd5;
    parameter VOL_SET = 3'd6;

    reg[2:0] state=0;
    always @(posedge clk) begin
        pre_sw<=sw;
        if(~RST || pre_sw!=sw) begin
            MP3_RSET<=0;
            cmd_cnt<=0;
            state<=RSET_OVER;
            cmd<=cmd_init;
            MP3_SCLK<=0;
            MP3_CS<=1;
            MP3_DCS<=1;
            cnt<=0;
            pos<=0;
        end
        else begin
            case(state)
            INITIALIZE:begin
                MP3_SCLK<=0;
                if(cmd_cnt>=cmd_cnt_max) begin
                    state<=CHECK;
                end
                else if(MP3_DREQ) begin
                    MP3_CS<=0;
                    cnt<=1;
                    state<=SEND_CMD;
                    MP3_MOSI<=cmd[127];
                    cmd<={cmd[126:0],cmd[127]};
                end
            end
            SEND_CMD:begin
                if(MP3_DREQ) begin
                    if(MP3_SCLK) begin
                        if(cnt<32)begin
                            cnt<=cnt+1;
                            MP3_MOSI<=cmd[127];
                            cmd<={cmd[126:0],cmd[127]};
                        end
                        else begin
                            MP3_CS<=1;
                            cnt<=0;
                            cmd_cnt<=cmd_cnt+1;
                            state<=INITIALIZE;
                        end
                    end
                    MP3_SCLK<=~MP3_SCLK;
                end
            end
            CHECK:begin
                if(vol[15:0]!=cmd_init[47:32]) begin
                    state<=VOL_SET_PRE;
                    next_cmd<={16'h020B,vol[15:0]};
                end
                else if(MP3_DREQ) begin
                    MP3_DCS<=0;
                    MP3_SCLK<=0;
                    state<=DATA_SEND;
                    case (sw)
                        3'd0:begin
                            data<={data0[14:0],data0[15]};
                            MP3_MOSI<=data0[15];
                        end
                        3'd1:begin
                            data<={data1[14:0],data1[15]};
                            MP3_MOSI<=data1[15];
                        end
                        3'd2:begin
                            data<={data2[14:0],data2[15]};
                            MP3_MOSI<=data2[15];
                        end
                        3'd3:begin
                            data<={data3[14:0],data3[15]};
                            MP3_MOSI<=data3[15];
                        end
                        3'd4:begin
                            data<={data4[14:0],data4[15]};
                            MP3_MOSI<=data4[15];
                        end
                        3'd5:begin
                            data<={data5[14:0],data5[15]};
                            MP3_MOSI<=data5[15];
                        end
                        3'd6:begin
                            data<={data6[14:0],data6[15]};
                            MP3_MOSI<=data6[15];
                        end 
                        default:begin
                            data<={data0[14:0],data0[15]};
                            MP3_MOSI<=data0[15];
                        end 
                    endcase
                    
                    cnt<=1;
                end
                cmd_init[47:32]<=vol;
            end
            DATA_SEND:begin 
                if(MP3_SCLK)begin
                    if(cnt<16)begin
                        cnt<=cnt+1;
                        MP3_MOSI<=data[15];
                        data<={data[14:0],data[15]};
                    end
                    else begin
                        MP3_DCS<=1;
                        pos<=pos+1;
                        state<=CHECK;
                    end
                end
                MP3_SCLK<=~MP3_SCLK;
            end
            RSET_OVER:begin
                if(cnt<1000000) begin
                    cnt<=cnt+1;
                end
                else begin
                    cnt<=0;
                    state<=INITIALIZE;
                    MP3_RSET<=1;
                end
            end
            VOL_SET_PRE:begin
                if(MP3_DREQ) begin
                    MP3_CS<=0;
                    cnt<=1;
                    state<=VOL_SET;
                    MP3_MOSI<=next_cmd[31];
                    next_cmd<={next_cmd[30:0],next_cmd[31]};
                end
            end
            VOL_SET:begin
                if(MP3_DREQ) begin
                    if(MP3_SCLK) begin
                        if(cnt<32)begin
                            cnt<=cnt+1;
                            MP3_MOSI<=next_cmd[31];
                            next_cmd<={next_cmd[30:0],next_cmd[31]};
                        end
                        else begin
                            MP3_CS<=1;
                            cnt<=0;
                            state<=CHECK;
                        end
                    end
                    MP3_SCLK<=~MP3_SCLK;
                end
            end
            default:begin
                ;
            end
            endcase
        end
    end

endmodule
