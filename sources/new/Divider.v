module  Divider #(parameter N=100000)
(
    DI,
    DO
);
    input DI;
    output reg DO=0;

    integer t_cnt=0;
    always @(posedge DI)begin
        if(t_cnt<N/2-1) begin
            t_cnt<=t_cnt+1;
        end
        else begin
            t_cnt<=0;
            DO<=~DO;
        end
    end
endmodule