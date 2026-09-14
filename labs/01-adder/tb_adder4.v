// =============================================================
// labs/01-adder/tb_adder4.v
// testbench（测试台）：只在仿真器里运行，永远不会被综合成电路。
// 它就是硬件世界的“单元测试”：
//   喂输入 -> 用软件方式算出期望值（参考模型）-> 逐组比对 -> 报错
// 文件名以 tb_ 开头，run_all.sh 靠这个前缀自动发现测试。
// =============================================================
`timescale 1ns/1ps
module tb_adder4;
    localparam WIDTH = 4;

    reg  [WIDTH-1:0] a, b;           // reg：测试台里由我们驱动的信号
    reg              cin;
    wire [WIDTH-1:0] sum;           // wire：接收被测模块的输出
    wire             cout;

    integer ia, ib, errors, golden;

    // 例化被测模块 DUT (Design Under Test)
    adder4 #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    initial begin
        // 记录波形到 wave.vcd，之后可用 GTKWave 打开观察信号随时间的变化
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_adder4);

        errors = 0;
        cin = 1'b0;
        // 穷举 16 x 16 = 256 种输入组合，仿真在毫秒内完成
        for (ia = 0; ia < (1 << WIDTH); ia = ia + 1) begin
            for (ib = 0; ib < (1 << WIDTH); ib = ib + 1) begin
                a = ia[WIDTH-1:0];
                b = ib[WIDTH-1:0];
                #1;                            // 等 1ns，让组合逻辑输出稳定
                golden = ia + ib;              // 软件参考模型：直接用整数加法
                if ({cout, sum} !== golden[WIDTH:0]) begin
                    $display("  [ERROR] %0d + %0d => got %0d, expected %0d",
                             ia, ib, {cout, sum}, golden);
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0)
            $display("[PASS] 01-adder: all %0d cases passed",
                     (1 << WIDTH) * (1 << WIDTH));
        else
            $display("[FAIL] 01-adder: %0d errors", errors);

        // 关键机制：出错时以非零状态退出，
        // Makefile 和 GitHub Actions 据此判定“红灯”
        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
