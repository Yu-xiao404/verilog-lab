// =============================================================
// labs/06-xorgate/tb_xor2.v —— 第二份 testbench（你来填 3 个空）
// 结构和 05-andgate 完全一样：你其实是在套同一个五段式模板，
// 换了被测电路，只需改“参考模型、判断、实验名”。
// 注意：答案写在【代码行】，不要写到 // 注释里！
// =============================================================
`timescale 1ns/1ps
module tb_xor2;
    reg  a, b;
    wire y;
    integer i;
    integer errors;
    reg expected;

    xor2 dut (
        .a(a), .b(b), .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_xor2);
        errors = 0;

        for (i = 0; i < 4; i = i + 1) begin
            a = i[1];
            b = i[0];
            #1;

            expected = a ^ b;// ★空1（参考模型）：异或的正确答案。
            //   想真值表：a、b 不同为 1。可以用异或运算符 ^，
            //   也可以写成“a 不等于 b”，两种都行，你选一种写在下面代码行。
            // ★空2（严格比对）：输出 y 和 expected 不一致就报错计数。
            //   回忆 05 用的四态严格不等号。
            if (y !==expected                     ) begin
                $display("  [ERROR] a=%0b b=%0b => got %0b, expected %0b",
                          a, b, y, expected);
                errors = errors + 1;
            end
        end

        // ★空3（文案）：把下面两处实验名改成 06-xorgate（数字仍是 4 组）
        if (errors == 0) $display("[PASS] 06-xorgate: all 4 cases passed");
        else             $display("[FAIL] 06-xorgate: %0d errors", errors);

        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
