`timescale 1ns/1ns
module datapath(
    input clk , rst , ldW1 , ldW2 , ldX1 , ldX2 , ldT , ldB,
    input signed [6:0] x1in, x2in,
    input signed [1:0] tin,
    output signed [1:0] tout,
    output eq
);
    reg signed [1:0] t ;
    reg signed [6:0] x1 , x2 ;
    reg signed [13:0] w1 , w2 , b ;

    reg signed [13:0] posAlpha = 14'b00000011000000;
    reg signed [13:0] negAlpha = 14'b11111101000000;

    wire signed [20:0] m1 , m2 , mw1 , mw2 ;
    wire signed [13:0] s , sw1 , sw2 , sb ;
    wire signed [13:0] alphaT ;

    assign alphaT = t[1] ? negAlpha : posAlpha ;

    assign m1 = x1 * w1 ;
    assign m2 = x2 * w2 ;

    assign s = m1[17:4] + m2[17:4] + b ;

    assign eq = ~(s[13] ^ t[1]) ;

    assign mw1 = x1 * alphaT ;
    assign mw2 = x2 * alphaT ;

    assign sw1 = mw1[17:4] + w1;
    assign sw2 = mw2[17:4] + w2;
    assign sb  = b + alphaT;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            w1 = 0 ; w2 = 0 ; b = 0 ;
        end
        else begin
            x1 = ldX1 ? x1in : x1;
            x2 = ldX2 ? x2in : x2;
            t  = ldT  ? tin  : t ;

            w1 = ldW1 ? sw1 : w1 ;
            w2 = ldW2 ? sw2 : w2 ;
            b  = ldB  ? sb  : b  ;
        end
    end

    assign tout = { s[13] , 1'b1 } ;
endmodule // datapath
