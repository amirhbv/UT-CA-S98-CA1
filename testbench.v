`timescale 1ns/1ns
module TB();
    reg clk = 0 , rst = 0 , start = 0 , EOI = 0 , EOF = 0 ;
    reg signed [6:0] x1 , x2 ;
    reg signed [1:0] tin ;
    wire learned , updating;
    wire signed [1:0] tout ;
    always #(20) clk = ~clk;

    neuron UUT(
        .clk(clk),
        .rst(rst),
        .start(start),
        .EOI(EOI),
        .EOF(EOF),
        .x1(x1),
        .x2(x2),
        .tin(tin),
        .tout(tout),
        .learned(learned),
        .updating(updating)
    );

    integer learn_file , test_file , out_file , i;

    initial begin
        rst = 1;
        #50 ;
        rst = 0;
        #50
        start = 1;
        #50
        start = 0;
            for (i = 0; i < 100; i = i + 1) begin
                learn_file = $fopen("learn_data.txt", "r");
                EOF = 0 ;
                while (!$feof(learn_file)) begin
                    $fscanf(learn_file, "%b %b %b\n", x1 , x2 , tin);
                    #20 ;
                    #20 ;
                    if (updating) begin
                        $display("%s %b %b %b\n", "updating", x1 , x2 , tin);
                        #20 ;
                        #20 ;
                    end
                end
                $fclose(learn_file);
                EOF = 1 ;
                #70 ;
                // if (learned) begin
                //     $display("learned in %d loops\n", i);
                //     i = 100 ;
                // end
            end
        #10000 ;
        start = 1;
        #71 ;
        start = 0 ;
        #71 ;
        test_file  = $fopen("test_data.txt", "r");
        out_file   = $fopen("out.txt", "w");
        while (!$feof(test_file)) begin
            $fscanf(test_file , "%b %b\n", x1 , x2);
            $fwrite(out_file , "%b\n" , tout);
            #20 ;
            #20 ;
        end
        EOI = 1 ;
        $fclose(test_file);
        $fclose(out_file);
        #50
        $stop;
    end
endmodule // TB
