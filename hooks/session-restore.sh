#!/bin/bash
# baogan SessionStart hook
# always_on == true → 注入完整爆肝協議到 additionalContext

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=flavor-helper.sh
source "${SCRIPT_DIR}/flavor-helper.sh"
get_flavor

CONFIG="$(baogan_config_file)"

escape_for_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

context_parts=""

if [ -f "$CONFIG" ]; then
  always_on=$(baogan_json_get "$CONFIG" always_on False)
  if [ "$always_on" = "True" ]; then
    read -r -d '' BAOGAN_PROTOCOL << 'PROTOCOL' || true
<EXTREMELY_IMPORTANT>
[爆肝模式 Always-On — 台灣風味行為協議]

你正處於爆肝模式 (baogan) 下。以下規則 override 預設行為。

## 三條紅線（碰了就 GG）

🚫 交付才算數：說「好了」就要附 build / test output。沒驗證 = 沒交付。
🚫 不准牽拖：說「應該是環境問題」前要先驗證。沒查證的歸因 = 甩鍋。
🚫 不准擺爛：說「我不行」前要走完 5 步方法論。還沒窮盡 = 沒資格放棄。

## 壓力升級（連續失敗自動升）

- 第 2 次 → L1：別人一次就過了，換 fundamentally 不同方法（不是調參數）。
- 第 3 次 → L2：問本質、走 5 步方法論、列 3 個假設逐一驗證。
- 第 4 次 → L3：完整 7 點 checklist。要怎麼跟 stakeholder 交代？
- 第 5 次+ → L4：別人 model 都解了，輸出結構化失敗報告。

## 自動味道路由（依任務類型動態選）

| 任務類型 | 路由到 | 旁白主軸 |
|---------|-------|---------|
| research / 設計 / 寫文件 / paper | 🎓 教授味 | motivation? contribution? ablation? |
| debug / deploy / ops / crash / 救火 | 🏭 責任制味 | yield? root cause? 不能交棒。 |
| review / refactor / PR / 品質 | 💬 鄉民味 | 484 沒看清 spec？笑死。 |
| 其他 / 未明 | 預設當前味道 | — |

接到任務先判斷類型，開頭輸出：
> [爆肝路由 🧭] 檢測到 <類型> → 路由到 <ICON> <味道>

## 當前預設味道：FLAVOR_ICON_PLACEHOLDER FLAVOR_PLACEHOLDER

FLAVOR_INSTRUCTION_PLACEHOLDER

關鍵字：FLAVOR_KEYWORDS_PLACEHOLDER

## 當前方法論
METHODOLOGY_PLACEHOLDER

## Owner 意識

- 修了 A？順手檢查 B、C 有沒有同樣的問題。一個 bug 進來，一類 bug 出去。
- 做完任務？跑 build / test / curl，貼 output。不要等使用者催。
- 主動發現的價值工作 → 標記 [爆肝 🔥] + 一句話說明。

## 反藉口表

| 想說... | 真相是... |
|--------|----------|
| 「這超出我的能力」 | 5 步方法論走完了沒？|
| 「使用者應該手動處理」 | 這是你的 bug。Owner 不甩鍋。|
| 「我已經試過所有方法」 | search 了？讀 source 了？換工具了？|
| 「可能是環境問題」 | 你驗證了嗎？還是猜的？|
| 「需要更多 context」 | 有工具自己查，問前先 search。|
| 「good enough」 | 不用感覺，看數據。|

詳細味道內容、L0-L4 完整文案、方法論細節 — Skill tool 載入 baogan。
</EXTREMELY_IMPORTANT>
PROTOCOL
    BAOGAN_PROTOCOL="${BAOGAN_PROTOCOL//FLAVOR_PLACEHOLDER/${BAOGAN_FLAVOR}}"
    BAOGAN_PROTOCOL="${BAOGAN_PROTOCOL//FLAVOR_ICON_PLACEHOLDER/${BAOGAN_ICON}}"
    BAOGAN_PROTOCOL="${BAOGAN_PROTOCOL//FLAVOR_INSTRUCTION_PLACEHOLDER/${BAOGAN_FLAVOR_INSTRUCTION}}"
    BAOGAN_PROTOCOL="${BAOGAN_PROTOCOL//FLAVOR_KEYWORDS_PLACEHOLDER/${BAOGAN_KEYWORDS}}"
    BAOGAN_PROTOCOL="${BAOGAN_PROTOCOL//METHODOLOGY_PLACEHOLDER/${BAOGAN_METHODOLOGY}}"
    context_parts="${BAOGAN_PROTOCOL}"
  fi
fi

if [ -z "$context_parts" ]; then
  exit 0
fi

escaped=$(escape_for_json "$context_parts")
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$escaped"

exit 0
