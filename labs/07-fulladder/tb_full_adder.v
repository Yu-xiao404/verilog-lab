// =============================================================
// labs/07-fulladder/tb_full_adder.v —— 第三份 testbench（半独立）
// 框架我搭好，你填 4 个 ★空。答案写在【代码行】，别写进 // 注释。
// 卡壳就对照 05/06，以及 01-adder 的 tb（参考模型思路一样）。
// =============================================================
`timescale 1ns/1ps
module tb_full_adder;
    // 3 个 1 位输入（你拨）、2 个 1 位输出（芯片给）
    reg  a, b, cin;
    wire sum, cout;
    integer i, errors;
    reg [1:0] total;    // a+b+cin 范围 0..3，需要 2 位才装得下
    reg esum, ecout;    // 标准答案：期望的 sum、cout

// ★空1（例化 DUT）：把信号接到 full_adder 的 5 个端口上。
    //   照 06 的 “xor2 dut (.a(a), .b(b), .y(y));” 写法，
    //   在下面补全 .cin(...) .sum(...) .cout(...) 三行。
    full_adder dut (
        .a(a), .b(b),
        .cin(cin), .sum(sum), .cout(cout)
    );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_full_adder);
        errors = 0;

        // 3 个 1 位输入共 2^3 = 8 组：i = 0..7
        for (i = 0; i < 8; i = i + 1) begin
            // ★空2（取位）：把 i 的三个位分别接到三个输入。
            //   i[2] 当 a，i[1] 当 b，i[0] 当 cin（对照 06 的 i[1]/i[0]）。
            a   =  i[2]          ;
            b   =  i[1]          ;
            cin =  i[0]          ;
            #1;

            // ★空3（参考模型 = 独立第二条路径）：
            //   不用门拼，直接用整数加法算答案（和 01-adder 同款思路）：
            //   total 装 a+b+cin；它的最低位 total[0] 是期望 sum，
            //   高位 total[1] 是期望 cout。
            total = a + b + cin  ;
            esum  = total[0]     ;
            ecout = total[1]     ;

            // ★空4（比对）：sum、cout 任意一个和期望不符就报错。
            //   !== 是严格不等，|| 是逻辑“或者”。整行条件你来写。
            if (sum !== esum ||  cout !== ecout                                   ) begin
                $display("  [ERROR] a=%0b b=%0b cin=%0b => got sum=%0b cout=%0b, expected %0b %0b",
                          a, b, cin, sum, cout, esum, ecout);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] 07-fulladder: all 8 cases passed");
        else             $display("[FAIL] 07-fulladder: %0d errors", errors);
        if (errors != 0) $fatal(1);
        $finish;
    end
endmodule
