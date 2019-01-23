module Vol_Set
(
    CLK,
    LEFT,
    RIGHT,
    VOL
);
    input CLK;
    input LEFT;
    input RIGHT;
    output reg [15:0]VOL=16'h0000;

    integer vol_delay=0;
    always @(negedge CLK) begin
        if(vol_delay==0) begin
            if(LEFT) begin
                vol_delay<=100000;
                VOL<=(VOL==16'h0000)?16'h0000:(VOL-16'h1010);
            end
            else if(RIGHT) begin
                vol_delay <= 100000;
                VOL<=(VOL==16'hf0f0)?16'hf0f0:(VOL+16'h1010);
            end
        end
        else begin
            vol_delay<=vol_delay-1;
        end
    end
    
endmodule