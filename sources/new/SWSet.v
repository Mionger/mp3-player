module SW_Set
(
    CLK,
    PREV,
    NEXT,
    SW
);
    input CLK;
    input [2:0]PREV;
    input [2:0]NEXT;
    output reg [2:0]SW=0;

    integer sw_delay=0;
    always @(negedge CLK) begin
        if(sw_delay==0) begin
            if(PREV) begin
                sw_delay<=500000;
                SW<=SW-PREV;
            end
            else if(NEXT) begin
                sw_delay <= 500000;
                SW<=SW+NEXT;
            end
        end
        else begin
            sw_delay<=sw_delay-1;
        end
    end
endmodule