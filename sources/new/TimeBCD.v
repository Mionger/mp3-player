module Time_BCD
(
    DI,
    DO
);
    input [15:0] DI;
    output [15:0] DO;

    assign DO[3:0]=DI % 10;
    assign DO[7:4]=(DI/10)%6;
    assign DO[11:8]=(DI/60)%10;
    assign DO[15:12]=DI/600;
endmodule