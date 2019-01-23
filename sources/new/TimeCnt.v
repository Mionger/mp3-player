module Time_Cnt
(
    CLK,
    RST,
    TIME_SEC
);
    input CLK;
    input RST;
    output reg [15:0] TIME_SEC=0;

    integer time_f=0;
    always @(negedge CLK) begin
        if(RST)begin
            time_f<=0;
            TIME_SEC<=0;
        end
        else begin
            if(time_f<999999) begin
                time_f<=time_f+1;
            end
            else begin
                time_f<=0;
                TIME_SEC<=TIME_SEC+1;
            end
        end
    end
    
endmodule