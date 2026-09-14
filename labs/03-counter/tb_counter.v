// =============================================================
// labs/03-counter/tb_counter.v
// 测试台分三段验证时序行为：复位 -> 连续计数 -> 使能拉低后“冻结”
// =============================================================
`timescale 1ns/1ps
module tb_counter;
    localparam WIDTH = 8;

    reg clk = 0;
    reg rst_n = 0;                    // 开头先处于复位状态
    reg en = 1;
    wire [WIDTH-1:0] cnt;

    integer step, errors;

    counter #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .en(en), .cnt(cnt)
    );

    // 生成周期 10ns 的时钟：每 5ns 翻转一次（50% 占空比）
    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_counter);
        errors = 0;

        // (1) 复位期间，输出必须为 0
        #12;
        if (cnt !== 0) begin
            $display("  [ERROR] in reset cnt=%0d, expected 0", cnt);
            errors = errors + 1;
        end

        // (2) 释放复位，连续 10 个时钟沿，每沿应 +1
        rst_n = 1;
        for (step = 1; step <= 10; step = step + 1) begin
            @(posedge clk); #1;       // 等上升沿，再等输出更新完
            if (cnt !== step[WIDTH-1:0]) begin
                $display("  [ERROR] step %0d cnt=%0d, expected %0d",
                         step, cnt, step);
                errors = errors + 1;
            end
        end

        // (3) en 拉低后，再过 3 个时钟沿，数值应冻结在 10
        en = 0;
        repeat (3) @(posedge clk);
        #1;
        if (cnt !== 10) begin
            $display("  [ERROR] paused cnt=%0d, expected 10", cnt);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("[PASS] 03-counter: reset/count/pause all passed");
        else
            $display("[FAIL] 03-counter: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
