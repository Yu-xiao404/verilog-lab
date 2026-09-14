# =============================================================
# Makefile —— 仓库的“任务入口”，作用类似 package.json scripts
#   make test                运行全部实验（默认 iverilog）
#   make test SIM=verilator  改用 verilator 运行
#   make list                列出所有实验目录
#   make wave-01-adder       用 GTKWave 打开指定实验的波形
#   make clean               清理仿真生成物
#
# 注意：Makefile 的缩进必须是 Tab，不是空格
# =============================================================
SIM ?= iverilog

.PHONY: all test list clean

all: test

test:
	@bash scripts/run_all.sh $(SIM)

list:
	@ls -d labs/*/

wave-%:
	@gtkwave build/$*.vcd &

clean:
	rm -rf build obj_dir wave.vcd
