module Rotation
(
    CLK,
    SIA,
    SIB,
    SW,
    Dir_O
);

    input CLK;
    input SIA;
    input SIB;
    input SW;
    output [1:0]Dir_O;

    reg [1:0]dir=0;
    
    reg sia1=1;
    reg sia2=1;
    wire sia_debounce=sia1 && sia2 && SIA;
    always@(posedge CLK or negedge SW) begin
      if(SW==0) begin
        sia1<=1;
        sia2<=1;
      end
      else begin
        sia1<=SIA;
        sia2<=sia1;  
      end
    end

    reg sib1=1;
    reg sib2=1;
    wire sib_debounce=sib1 && sib2 && SIB;
    always@(posedge CLK or negedge SW) begin
      if(SW==0) begin
        sib1<=1;
        sib2<=1;
      end
      else begin
        sib1<=SIB;
        sib2<=sib1;  
      end
    end
    
    reg sia3=1;
    reg sia4=1;
    wire sia_raise=sia3 && ~sia4;
    wire sia_fall=~sia3 && sia4;
    always@(posedge CLK or negedge SW) begin
      if(SW==0) begin
        sia3<=1;
        sia3<=1;
      end
      else begin
        sia3<=sia_debounce;
        sia4<=sia3;  
      end
    end


    parameter IDLE = 3'd0;
    parameter LEFT_START = 3'd1;
    parameter LEFT = 3'd2;
    parameter LEFT_OVER = 3'd3;
    parameter RIGHT_START = 3'd4;
    parameter RIGHT = 3'd5;
    parameter RIGHT_OVER = 3'd6;
    reg [2:0]current_state=IDLE;
    reg [2:0]next_state;

    always@(posedge CLK) begin
      if(SW==0)begin
        current_state<=IDLE;
      end
      else begin
        current_state<=next_state;
      end
    end

    always@(*)begin
      case (current_state)
        IDLE:begin
          if(sia_raise)begin
            if(sib_debounce==1'b1)begin
              next_state<=RIGHT_START;
            end
            else begin
              next_state<=LEFT_START;
            end
          end
          else begin
            next_state=IDLE;
          end
        end
        LEFT_START:begin
          next_state<=LEFT;
        end 
        LEFT:begin
          if(sia_fall && sib_debounce==1'b0)begin
            next_state=LEFT_OVER;
          end
          else begin
            next_state=LEFT;
          end
        end
        LEFT_OVER:begin
          next_state=IDLE;
        end
        RIGHT_START:begin
          next_state<=RIGHT;
        end 
        RIGHT:begin
          if(sia_fall && sib_debounce==1'b1)begin
            next_state=RIGHT_OVER;
          end
          else begin
            next_state=RIGHT;
          end
        end
        RIGHT_OVER:begin
          next_state=IDLE;
        end
        default:begin
          next_state=IDLE;
        end
      endcase
    end

    always@(*)begin
      case (current_state)
        IDLE:begin
          dir<=2'b00;
        end
        LEFT_START:begin
          dir<=2'b00;
        end 
        LEFT:begin
          dir<=2'b10;
        end
        LEFT_OVER:begin
          dir<=2'b00;
        end
        RIGHT_START:begin
          dir<=2'b00;
        end 
        RIGHT:begin
          dir<=2'b01;
        end
        RIGHT_OVER:begin
          dir<=2'b00;
        end
        default:begin
          dir<=2'b00;
        end
      endcase
    end

    assign Dir_O = dir;

endmodule