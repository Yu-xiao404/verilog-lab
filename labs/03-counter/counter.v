// =============================================================
// labs/03-counter/counter.v
// 8 位计数器 —— 时序逻辑入门
//
// 【知识点】时序逻辑：有记忆，状态只在时钟 clk 的上升沿更新，
// 类似软件里“持有字段、在事件触发时修改字段的对象”。
// 触发器（Flip-Flop）是芯片里最小的记忆元件，
// 寄存器堆、缓存、SRAM 都由它构成。
// 【真实芯片里的位置】CPU 的程序计数器 PC、定时器、
// UART 波特率发生器、时钟分频器。
// =============================================================
module counter #(
    parameter WIDTH = 8
)(
    input  wire             clk,     // 时钟：整个芯片的“心跳”
    input  wire             rst_n,   // 复位，低电平有效（active low，业界惯例）
    input  wire             en,      // 使能：1=计数，0=保持不动
    output reg  [WIDTH-1:0] cnt
);
    // posedge clk = 时钟上升沿；时序逻辑统一用非阻塞赋值 <=
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= {WIDTH{1'b0}};
        else if (en)
            cnt <= cnt + 1'b1;
    end
endmodule
