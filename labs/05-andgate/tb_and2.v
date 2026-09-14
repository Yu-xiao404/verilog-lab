// =============================================================
// labs/05-andgate/tb_and2.v —— 你的第一份“自己写”的 testbench
// 五段式骨架已经搭好，你只需要填两个 ★空。
// =============================================================
`timescale 1ns/1ps
module tb_and2;
    // —— 第①  ② 段：声明信号 ——
    reg  a, b;       // 输入：由测试台主动“拨开关”，用 reg
    wire y;          // 输出：由与门驱动、测试台只读取，用 wire
    integer i;       // 循环变量
    integer errors;  // 错误计数
    reg expected;    // 标准答案

    // —— 第③ 段：例化被测电路 DUT（.芯片端口(你接的线)）——
    and2 dut (
        .a(a), .b(b), .y(y)
    );

    // —— 第④ ⑤ 段：initial begin...end 就是“测试主程序”——
    initial begin
        $dumpfile("wave.vcd");      // 记录波形，供 GTKWave 看
        $dumpvars(0, tb_and2);
        errors = 0;

        // 2 个 1 位输入共 2^2 = 4 种组合：i = 0..3，拆出它的两位当 a、b
        for (i = 0; i < 4; i = i + 1) begin
            a = i[1];
            b = i[0];
            #1;                     // 等 1ns，让与门输出稳定再读

            // 参考模型：与门的正确答案（下面这行才是真正会执行的“代码”，不是注释）
            expected = a & b;

            // 严格比对：输出 y 与标准答案 expected 不一致就打印并计数
            if (y !== expected) begin
                $display("  [ERROR] a=%0b b=%0b => got %0b, expected %0b",
                          a, b, y, expected);
                errors = errors + 1;
            end
        end

        // —— 第⑤段：汇总判卷；有错就用非零退出码让 make / CI 变红 ——
        if (errors == 0) $display("[PASS] 05-andgate: all 4 cases passed");
        else             $display("[FAIL] 05-andgate: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
