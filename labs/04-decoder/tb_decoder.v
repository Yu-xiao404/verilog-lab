// =============================================================
// labs/04-decoder/tb_decoder.v
// 3-8 译码器测试台：en × sel(3位) = 2 × 8 = 16 组穷举。
// 设计文件 decoder.v 由你自己编写（模块名必须叫 decoder）。
// =============================================================
`timescale 1ns/1ps
module tb_decoder;
    reg  [2:0] sel;
    reg        en;
    wire [7:0] y;

    integer k, errors;
    reg [7:0] expected;

    // 例化你要写的译码器
    decoder dut (
        .sel(sel), .en(en), .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_decoder);

        errors = 0;
        // k=0..7 时 en=0；k=8..15 时 en=1，低 3 位是 sel，共覆盖 16 种组合
        for (k = 0; k < 16; k = k + 1) begin
            en  = k[3];
            sel = k[2:0];
            #1;
            // 参考模型：en=0 全 0；en=1 时把 1 左移 sel 位（one-hot）
            expected = en ? (8'b00000001 << sel) : 8'b00000000;
            if (y !== expected) begin
                $display("  [ERROR] en=%0b sel=%0d => got %b, expected %b",
                         en, sel, y, expected);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] 04-decoder: all 16 cases passed");
        else             $display("[FAIL] 04-decoder: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
