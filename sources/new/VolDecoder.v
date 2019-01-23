module Vol_Decoder
(
    DI,
    DO
);

    input [15:0]DI;
    output reg [15:0]DO;

    always@(*)begin
        case (DI)
            16'h0000:begin
                DO=16'b1111111111111111;
            end
            16'h1010:begin
                DO=16'b0111111111111111;
            end
            16'h2020:begin
                DO=16'b0011111111111111;
            end
            16'h3030:begin
                DO=16'b0001111111111111;
            end
            16'h4040:begin
                DO=16'b0000111111111111;
            end
            16'h5050:begin
                DO=16'b0000011111111111;
            end
            16'h6060:begin
                DO=16'b0000001111111111;
            end
            16'h7070:begin
                DO=16'b0000000111111111;
            end
            16'h8080:begin
                DO=16'b0000000011111111;
            end
            16'h9090:begin
                DO=16'b0000000001111111;
            end
            16'hA0A0:begin
                DO=16'b0000000000111111;
            end
            16'hB0B0:begin
                DO=16'b0000000000011111;
            end
            16'hC0C0:begin
                DO=16'b0000000000001111;
            end
            16'hD0D0:begin
                DO=16'b0000000000000111;
            end
            16'hE0E0:begin
                DO=16'b0000000000000011;
            end
            16'hF0F0:begin
                DO=16'b0000000000000001;
            end 
            default: begin
                ;
            end
        endcase
    end
endmodule