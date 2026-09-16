// =============================================================
// labs/09-acc/tb_acc4.v   —— 正确答案版（已自测 ALL 9 PASSED）
// 时序 testbench 三板斧：① 自己造时钟 ② 沿前给激励、沿后核对 ③ 参考模型逐拍推进
// =============================================================
`timescale 1ns/1ps
module tb_acc4;
    localparam WIDTH = 4;

    reg               clk   = 0;
    reg               rst_n = 0;   // 开头先处于复位
    reg               en    = 0;
    reg  [WIDTH-1:0]  d     = 0;
    wire [WIDTH-1:0]  q;

    integer tick, errors, exp;    // exp：参考模型期望值，用 %16 模拟 4 位回绕

    acc4 #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .en(en), .d(d), .q(q)
    );

    // ① 周期 10ns 的时钟：每 5ns 翻转一次（固定套路，不用改）
    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_acc4);
        errors = 0;
        exp = 0;

        // (1) 复位期跑 2 拍，q 必须保持 0
        repeat (2) @(posedge clk);
        #1;
        if (q !== 0) begin
            $display("  [ERROR] in reset q=%0d, expected 0", q);
            errors = errors + 1;
        end

        // (2) 释放复位、使能，逐拍喂 d=3,4,5,6 → q 应为 3,7,12,(18 回绕成 2)
        rst_n = 1;
        en    = 1;
        for (tick = 0; tick < 4; tick = tick + 1) begin
            d = 3 + tick;          // 沿【前】把本拍输入准备好
            @(posedge clk); #1;    // 【空1】等上升沿，再等 q 更新稳定
            // 【空2】参考模型：独立第二条路，用软件取模模拟 4 位回绕
            if (rst_n == 0) exp = 0;
            else if (en)    exp = (exp + d) % 16;
            // 【空3】比对：q 与 exp 低 4 位不一致就报错
            if (q !== exp[WIDTH-1:0]) begin
                $display("  [ERROR] add tick=%0d q=%0d, expected %0d", tick, q, exp);
                errors = errors + 1;
            end
        end

        // (3) 冻结：en=0 跑 2 拍，q 必须不变（exp 也不动）
        en = 0; d = 15;
        repeat (2) @(posedge clk);
        #1;
        if (q !== exp[WIDTH-1:0]) begin
            $display("  [ERROR] hold q=%0d, expected %0d", q, exp);
            errors = errors + 1;
        end

        // (4) 重新使能，d=5 跑 2 拍 → 2,7,12
        en = 1; d = 5;
        repeat (2) begin
            @(posedge clk); #1;
            if (rst_n == 0) exp = 0;
            else if (en)    exp = (exp + d) % 16;
            if (q !== exp[WIDTH-1:0]) begin
                $display("  [ERROR] resume q=%0d, expected %0d", q, exp);
                errors = errors + 1;
            end
        end

        // (5) 中途把复位拉低 1 拍，q 应立刻清 0
        rst_n = 0;
        @(posedge clk); #1;
        exp = 0;
        if (q !== 0) begin
            $display("  [ERROR] re-reset q=%0d, expected 0", q);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("[PASS] 09-acc: reset/add/wrap/hold all passed");
        else
            $display("[FAIL] 09-acc: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
