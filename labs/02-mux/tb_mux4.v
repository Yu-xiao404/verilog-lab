// =============================================================
// labs/02-mux/tb_mux4.v
// 测试台：遍历 sel 的 4 个取值，检查输出是否选对了输入通道。
// =============================================================
`timescale 1ns/1ps
module tb_mux4;
    localparam WIDTH = 8;

    reg  [WIDTH-1:0] d0, d1, d2, d3;
    reg  [1:0]       sel;
    wire [WIDTH-1:0] y;

    integer k, errors;
    reg [WIDTH-1:0] expected;

    mux4 #(.WIDTH(WIDTH)) dut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mux4);

        errors = 0;
        // 四路给互不相同的值，一旦“选错路”立刻能看出来
        d0 = 8'h11; d1 = 8'h22; d2 = 8'h33; d3 = 8'h44;

        for (k = 0; k < 4; k = k + 1) begin
            sel = k[1:0];
            #1;
            expected = (k == 0) ? d0 :
                       (k == 1) ? d1 :
                       (k == 2) ? d2 : d3;
            if (y !== expected) begin
                $display("  [ERROR] sel=%0d => got %h, expected %h",
                         k, y, expected);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] 02-mux: all select cases passed");
        else             $display("[FAIL] 02-mux: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
