// =============================================================
// labs/08-magcmp/mag2.v —— 2 位数值比较器（magnitude comparator）
// 作用：比较两个 2 位无符号数 a、b（取值 0~3），输出三个互斥标志：
//   gt (greater than) ：a > b 时为 1
//   eq (equal)        ：a = b 时为 1
//   lt (less than)    ：a < b 时为 1
// 真实芯片里的位置：CPU 的 ALU 做 if(a>b) 这类条件判断，靠的就是比较器。
// 知识点：Verilog 可以直接对多位向量做 >  ==  < 比较，结果是 1 位。
// 组合数：a 有 4 种 × b 有 4 种 = 16 组。
// =============================================================
module mag2(
    input  wire [1:0] a,
    input  wire [1:0] b,
    output wire gt,
    output wire eq,
    output wire lt
);
    assign gt = (a >  b);
    assign eq = (a == b);
    assign lt = (a <  b);
endmodule
