`timescale 1ns/1ps
module tb_mag2;
    // —— 第①②段：声明 ——
    reg  [1:0] a, b;          // 两个 2 位输入
    wire gt, eq, lt;          // 三个 1 位输出
    integer ia, ib, errors;   // 双层循环变量 + 错误计数
    reg egt, eeq, elt;        // 三个标准答案

    // —— 第③段：例化（模块名是 mag2，不是目录名 magcmp）——
    mag2 dut ( .a(a), .b(b), .gt(gt), .eq(eq), .lt(lt) );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mag2);
        errors = 0;

        // —— 第④段：双层 for 穷举 4×4=16 组，两层都配 begin/end ——
        for (ia = 0; ia < 4; ia = ia + 1) begin
            for (ib = 0; ib < 4; ib = ib + 1) begin
                a = ia[1:0];
                b = ib[1:0];
                #1;
                // 参考模型：用整数直接比较（独立第二条路径）
                egt = (ia >  ib);
                eeq = (ia == ib);   // 相等判断是两个等号 ==
                elt = (ia <  ib);
                // 三个输出任意一个不符就报错：if 体用 begin/end 包住两句
                if (gt !== egt || eq !== eeq || lt !== elt) begin
                    $display("  [ERROR] A=%0d B=%0d => g/e/l=%0b%0b%0b, exp %0b%0b%0b",
                              ia, ib, gt, eq, lt, egt, eeq, elt);
                    errors = errors + 1;
                end
            end
        end

        // —— 第⑤段：汇总判卷（在双层 for 之外，只执行一次）——
        if (errors == 0) $display("[PASS] 08-magcmp: all 16 cases passed");
        else             $display("[FAIL] 08-magcmp: %0d errors", errors);
        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
