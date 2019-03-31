`timescale 1ns/1ns
module neuron(
    input clk , rst , start , EOI , EOF ,
    input signed [6:0] x1 , x2 ,
    input signed [1:0] tin ,
    output learned , updating ,
    output signed [1:0] tout
);
    wire ldW1 , ldW2 , ldX1 , ldX2 , ldT , ldB , eq ;
    datapath dp(
        .clk(clk),
        .rst(rst),
        .ldW1(ldW1),
        .ldW2(ldW2),
        .ldX1(ldX1),
        .ldX2(ldX2),
        .ldT(ldT),
        .ldB(ldB),
        .eq(eq),
        .x1in(x1),
        .x2in(x2),
        .tin(tin),
        .tout(tout)
    );
    controller ct(
        .clk(clk),
        .rst(rst),
        .ldW1(ldW1),
        .ldW2(ldW2),
        .ldX1(ldX1),
        .ldX2(ldX2),
        .ldT(ldT),
        .ldB(ldB),
        .eq(eq),
        .EOF(EOF),
        .EOI(EOI),
        .start(start),
        .learned(learned),
        .updating(updating)
    );
endmodule // neuron
