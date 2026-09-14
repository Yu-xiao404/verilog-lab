# Lab 02 — 4 选 1 多路选择器（组合逻辑）

## 这个电路在干什么

`sel` 是 2 位选择信号，决定把 `d0~d3` 中哪一路接到输出 `y`，相当于一个单刀四掷开关。

**在真实芯片里**：MUX 是数字电路中出现频率最高的结构之一——ALU 用它选操作数、寄存器堆用它选读哪个寄存器、总线用它分时复用多个发送方。「任何组合逻辑都可以化成 MUX 阵列」，所以它也是 FPGA 查找表（LUT）的基本原理。

## 文件

- `mux4.v`：用 `always @(*) + case` 描述（01 是 `assign` 写法，两种写法都要会）。
- `tb_mux4.v`：四路给不同值，遍历 `sel` 检查有没有「选错路」。

## 运行

```bash
iverilog -g2012 -o build/02.vvp labs/02-mux/*.v && vvp build/02.vvp
make wave-02-mux
```

预期：`[PASS] 02-mux: all select cases passed`。

## 学习要点

1. **为什么 always 里输出要声明成 `reg`**：Verilog 语法规定，`always` 过程块中被赋值的变量必须是 reg 型——但注意它**不代表物理寄存器（触发器）**，组合逻辑的 reg 综合后仍是导线和门。
2. **`default` 分支为什么必须写**：组合逻辑若某输入组合没有赋到值，综合器会推断出锁存器（latch）偷偷「记住」旧值，时序和功耗都会出问题。可以故意删掉 default，再用 Yosys 看警告。
3. 阻塞赋值 `=` 用于组合逻辑；时序逻辑才用 `<=`，对比 lab 03。

## 挑战题（由易到难）

1. 用 `assign y = ... ? ... : ...;` 三元运算符嵌套重写一遍，testbench 不变。
2. 用 `generate + for` 写一个参数化的 `N 选 1` 选择器（N 必须是 2 的幂，sel 位宽用 `$clog2`）。
3. 安装 Yosys（`apt install yosys`），对「有 default / 无 default」两版分别执行 `synth -top mux4`，观察它报告的单元数量差异，亲手看到 latch 是怎么被推断出来的。
