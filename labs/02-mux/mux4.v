// =============================================================
// labs/02-mux/mux4.v
// 4 选 1 多路选择器 —— 组合逻辑的第二种写法（always + case）
//
// sel 像一个开关：决定把 d0~d3 中哪一路接到输出 y。
// 【真实芯片里的位置】CPU 里 ALU 的操作数选择、寄存器堆读口、
// 片上总线的时分复用，本质都是 MUX。
// =============================================================
module mux4 #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] d0,
    input  wire [WIDTH-1:0] d1,
    input  wire [WIDTH-1:0] d2,
    input  wire [WIDTH-1:0] d3,
    input  wire [1:0]       sel,    // 2 位选择信号：00/01/10/11
    output reg  [WIDTH-1:0] y       // 在 always 块中赋值，必须声明为 reg
);
    // @(*) = “任意输入变化就重新执行一遍”，组合逻辑的固定写法
    always @(*) begin
        case (sel)
            2'd0: y = d0;
            2'd1: y = d1;
            2'd2: y = d2;
            2'd3: y = d3;
            default: y = {WIDTH{1'b0}}; // 必须覆盖所有分支，否则综合器
                                        // 会推断出意外的“锁存器”
        endcase
    end
endmodule
