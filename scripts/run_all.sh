#!/usr/bin/env bash
# =============================================================
# run_all.sh —— 批量运行 labs/ 下所有 testbench
#
# 用法:
#   bash scripts/run_all.sh             # 默认 iverilog 后端
#   bash scripts/run_all.sh verilator   # 可选 verilator 后端
#
# 退出码（CI 就是靠它判断红绿）:
#   0 = 全部通过   1 = 至少一个失败
# =============================================================
set -u

SIM="${1:-iverilog}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 1
mkdir -p build
fail=0
total=0

for dir in labs/*/; do
    name="$(basename "$dir")"
    tb="$(ls "$dir"tb_*.v 2>/dev/null | head -n1)"
    if [ -z "$tb" ]; then
        echo "== skip  $name (no testbench)"
        continue
    fi

    total=$((total + 1))
    echo "== run   $name  ($SIM)"
    rm -f wave.vcd

    if [ "$SIM" = "verilator" ]; then
        top="$(basename "$tb" .v)"
        # --binary 直接编译为可执行文件；--timing 允许 testbench 里的 # 延时
        if verilator --binary --timing -Wno-fatal --top-module "$top" "$dir"*.v; then
            "./obj_dir/V$top" || fail=1
        else
            fail=1
        fi
    else
        # -g2012 启用现代 Verilog 语法；先编译成 .vvp，再用 vvp 运行
        if iverilog -g2012 -o "build/$name.vvp" "$dir"*.v; then
            vvp "build/$name.vvp" || fail=1
        else
            fail=1
        fi
    fi

    # 把波形统一收进 build/，以实验名命名
    [ -f wave.vcd ] && mv -f wave.vcd "build/$name.vcd"
done

echo "------------------------------------------"
if [ "$fail" -eq 0 ]; then
    echo "ALL $total LABS PASSED"
else
    echo "SOME LABS FAILED (ran $total)"
fi
exit "$fail"
