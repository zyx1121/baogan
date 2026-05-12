#!/bin/bash
# baogan UserPromptSubmit hook
# 偵測使用者挫折詞 → 注入風格化的升壓 trigger

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=style-helper.sh
source "${SCRIPT_DIR}/style-helper.sh"

# always_on=False 時仍偵測 trigger，但只在 user 明確挫折時注入
HOOK_INPUT=$(cat || true)
PY=$(baogan_python_cmd 2>/dev/null || printf 'python3')

USER_PROMPT=$(printf '%s' "$HOOK_INPUT" | "$PY" -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('prompt') or d.get('message') or d.get('user_prompt') or '')
except Exception:
    print(sys.stdin.read())" 2>/dev/null || echo "$HOOK_INPUT")

# 台灣 + 中英文挫折觸發詞
TRIGGER_RE='try harder|stop giving|figure it out|you keep failing|stop spinning|you broke|again\?\?\?|又失敗|還不行|為什麼還不|怎麼又|加油好嗎|擺爛|做不到|搞不定|跑不起來|484 不|484不|484 沒|484沒|484 ?$|/baogan|爆肝模式|別擺爛|不會 ?$|笑死|你又|GG 了|gg 了|/pua'

if ! printf '%s' "$USER_PROMPT" | grep -Eiq "$TRIGGER_RE"; then
  exit 0
fi

get_style

cat << EOF
<BAOGAN_TRIGGER>
[爆肝 ${BAOGAN_ICON} — 偵測到使用者挫折訊號]

User 看不下去了。立刻：
1. 從 L1 起跳（連續失敗多就更高）
2. 換 fundamentally 不同的方法 — 不是調參數、不是再 retry 一次
3. 給驗證證據：跑的指令、output、剩餘風險
4. 三條紅線：交付才算數 / 不准牽拖 / 不准擺爛
5. 不要找藉口、不要甩鍋環境、不要叫 user 自己處理

> ${BAOGAN_L1}

當前風格：${BAOGAN_STYLE} ${BAOGAN_ICON}
${BAOGAN_STYLE_INSTRUCTION}
</BAOGAN_TRIGGER>
EOF

exit 0
