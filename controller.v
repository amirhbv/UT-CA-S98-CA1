`timescale 1ns/1ns
module controller(
  input clk , rst , eq , start , EOF , EOI ,
  output reg ldW1 , ldW2 , ldX1 , ldX2 , ldT , ldB , updating ,
  output learned
);
    reg [2:0] ns , ps;
    reg _learned = 0;
    assign learned = _learned ;

    parameter [2:0] idle = 0, starting = 1, toLearn = 2 , getX = 3, upadteWeight = 4 , getTestInput = 5 ;

    always @ (ps , eq , start , EOF , EOI) begin
        case (ps)
            idle      : ns = start ? starting : idle ;
            starting  : ns = _learned ? getTestInput : toLearn ;
            toLearn   : ns = getX ;
            getX      : begin
                if (EOF) begin
                    ns = starting;
                end else begin
                    if (eq)
                        ns = getX;
                    else if(~eq)
                        ns = upadteWeight;
                end
            end
            upadteWeight : ns = getX ;
            getTestInput : ns = EOI ? idle : getTestInput ;
            default: ns = idle;
        endcase
    end

    always @ (ps , eq) begin
        ldW1 = 0 ; ldW2 = 0 ; ldX1 = 0 ; ldX2 = 0 ; ldT = 0 ; ldB = 0 ; updating = 0 ;
        case (ps)
            toLearn : begin
                _learned = 1;
            end
            getX: begin
                ldX1    = 1 ;
                ldX2    = 1 ;
                ldT     = 1 ;
                if (~eq) begin
                    updating = 1 ;
                end
            end
            upadteWeight: begin
                ldW1    = 1 ;
                ldW2    = 1 ;
                ldB     = 1 ;
                _learned = 0 ;
            end
            getTestInput: begin
                ldX1 = 1 ;
                ldX2 = 1 ;
            end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst) ps <= idle;
        else ps <= ns;
    end
endmodule // contoller
