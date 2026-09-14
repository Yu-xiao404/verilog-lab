# verilog-lab

[![ci](https://github.com/Yu-xiao404/verilog-lab/actions/workflows/test.yml/badge.svg)](https://github.com/Yu-xiao404/verilog-lab/actions/workflows/test.yml)

> 计算机专业学生的「数字芯片设计」以做代练仓库：用写代码、写测试、跑 CI 的方式入门半导体数字设计。
> 不需要任何硬件基础，不需要芯片开发板，一台能装 Linux 终端的电脑即可。

## 这个仓库在练什么

半导体数字芯片的设计流程，和你熟悉的软件开发几乎一一对应：**写 RTL（≈写源码）→ 仿真（≈单元测试）→ 综合（≈编译）→ 布局布线（≈链接/装载）→ 流片（≈发布，且无法打补丁）**。

本仓库先只攻最前面、也是成本最低的两步：**用 Verilog 描述电路 + 自检式仿真验证**。完整背景见 [`docs/01-半导体与数字芯片设计扫盲.md`](docs/01-半导体与数字芯片设计扫盲.md)，动手前建议先读它（约 15 分钟）。

## 环境准备（一次性）

开源 EDA 工具基本只支持 Linux，Windows 用户请用 WSL2。

**Windows（管理员 PowerShell）**
```powershell
wsl --install -d Ubuntu      # 装完重启，设置 Ubuntu 用户名密码
```
然后进入 Ubuntu 终端执行下面的 Ubuntu 命令。Windows 磁盘在 `/mnt/c/...` 下。

**Ubuntu / Debian（含 WSL2）**
```bash
sudo apt-get update
sudo apt-get install -y iverilog make gtkwave
```

**macOS**
```bash
brew install icarus-verilog make gtkwave
```

验证安装：`iverilog -V` 能打印版本号即可。

## 怎么运行

```bash
make test                   # 一键跑全部实验，全绿才算通过
make list                   # 查看有哪些实验
make wave-01-adder          # 用 GTKWave 打开 01 实验的波形（需图形界面）
make clean                  # 清理 build/ 生成物
```

单独跑某个实验（以 01 为例）：
```bash
iverilog -g2012 -o build/01-adder.vvp labs/01-adder/*.v
vvp build/01-adder.vvp
```

## 实验目录

| 实验 | 电路 | 逻辑类型 | 对应真实芯片部件 | 核心训练点 |
|---|---|---|---|---|
| [01-adder](labs/01-adder/) | 4 位加法器 | 组合逻辑 | ALU、地址计算 | 穷举测试、参考模型、位拼接进位 |
| [02-mux](labs/02-mux/) | 4 选 1 选择器 | 组合逻辑 | 操作数选择、总线复用 | always/case、避免锁存、参数化 |
| [03-counter](labs/03-counter/) | 8 位计数器 | 时序逻辑 | PC、定时器、波特率发生器 | 时钟、复位、非阻塞赋值、使能 |

每个实验目录下：`*.v`（电路本身）+ `tb_*.v`（自检测试台）+ `README.md`（原理与挑战题）。

## 推荐的做练节奏

1. **先跑通**：clone 后 `make test`，看到 3 个 `[PASS]`。
2. **再读懂**：按 01→02→03 顺序读代码注释，对照各自 README。
3. **故意改坏**：比如把加法器的 `cin` 删掉、把计数器的 `<=` 改成 `=`，观察测试如何变红——先学会让测试抓到 bug。
4. **做挑战题**：每个 lab README 末尾都有 3 道递进挑战，自己新建分支完成。
5. **持续扩充**：每学会一个新电路，就按同样的目录规范加一个 `lab`，CI 会自动把它纳入测试。

## 进阶路线（本仓库之后）

- `04-fifo` / `05-uart-tx` / `06-spi`：常见接口模块
- 自制 RISC-V RV32I 小核（硬件线）或 RISC-V 指令集模拟器（软件线，CS 更顺手）
- SkyWater SKY130 开源工艺库 + OpenLane，把 RTL 一路跑到 GDSII 版图，甚至通过 TinyTapeout 真实流片
- 给 Verilator / Yosys / OpenROAD / KLayout 等开源 EDA 项目提交 PR

## Git 工作流（每个练习都走一遍，练出手感）

```bash
git checkout -b lab/04-fifo          # 新练习开新分支
git add . && git commit -m "feat: add synchronous FIFO with self-checking tb"
git push -u origin lab/04-fifo       # 推送后在 GitHub 网页发起 Pull Request
```
PR 页面会自动运行 `.github/workflows/test.yml`：绿灯 = 测试通过，这就是你的硬件 CI 闭环。

## License

MIT，见 [LICENSE](LICENSE)。
