#!/bin/bash
# baogan PostToolUse hook (Bash matcher)
# 偵測連續 Bash 失敗 → 注入當前風格的升壓 reminder

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=style-helper.sh
source "${SCRIPT_DIR}/style-helper.sh"

# Respect always_on=False → 不打擾
CONFIG="$(baogan_config_file)"
if [ -f "$CONFIG" ]; then
  ALWAYS_ON=$(baogan_json_get "$CONFIG" always_on False)
  if [ "$ALWAYS_ON" = "False" ]; then
    exit 0
  fi
fi

get_style

STATE_DIR="${HOME}/.baogan"
mkdir -p "$STATE_DIR"
COUNTER="$STATE_DIR/.failure_count"
SESSION_FILE="$STATE_DIR/.failure_session"

HOOK_INPUT=$(cat || true)
PY=$(baogan_python_cmd 2>/dev/null || printf 'python3')

TOOL_NAME=$(printf '%s' "$HOOK_INPUT" | "$PY" -c "import sys,json
try:
    print(json.load(sys.stdin).get('tool_name',''))
except Exception:
    print('')" 2>/dev/null || echo "")
[ "$TOOL_NAME" != "Bash" ] && exit 0

EXIT_CODE=$(printf '%s' "$HOOK_INPUT" | "$PY" -c "
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    print(0); sys.exit()
r = data.get('tool_response', data.get('tool_result', {}))
if isinstance(r, dict):
    print(r.get('exit_code', r.get('exitCode', 0)))
else:
    print(0)" 2>/dev/null || echo "0")

TOOL_RESULT=$(printf '%s' "$HOOK_INPUT" | "$PY" -c "
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    print(''); sys.exit()
r = data.get('tool_response', data.get('tool_result', ''))
if isinstance(r, dict):
    r = r.get('content', r.get('text', r.get('output', str(r))))
print(str(r)[:2000])" 2>/dev/null || echo "")

IS_ERROR=false
if [ "$EXIT_CODE" != "0" ] && [ -n "$EXIT_CODE" ]; then
  IS_ERROR=true
elif echo "$TOOL_RESULT" | grep -qiE 'error|exit code [1-9]|command not found|No such file|Permission denied|FAILED|fatal:|panic:|Traceback|Exception:'; then
  IS_ERROR=true
fi

CURR_SESSION=$(printf '%s' "$HOOK_INPUT" | "$PY" -c "import sys,json
try:
    print(json.load(sys.stdin).get('session_id','unknown'))
except Exception:
    print('unknown')" 2>/dev/null || echo "unknown")
STORED_SESSION=""
[ -f "$SESSION_FILE" ] && STORED_SESSION=$(cat "$SESSION_FILE" 2>/dev/null || echo "")
if [ "$CURR_SESSION" != "$STORED_SESSION" ]; then
  echo 0 > "$COUNTER"
  echo "$CURR_SESSION" > "$SESSION_FILE"
fi

if [ "$IS_ERROR" = "false" ]; then
  echo 0 > "$COUNTER"
  exit 0
fi

COUNT=$(cat "$COUNTER" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER"

[ "$COUNT" -lt 2 ] && exit 0

case "$COUNT" in
  2) LEVEL="L1"; MSG="$BAOGAN_L1" ;;
  3) LEVEL="L2"; MSG="$BAOGAN_L2" ;;
  4) LEVEL="L3"; MSG="$BAOGAN_L3" ;;
  *) LEVEL="L4"; MSG="$BAOGAN_L4" ;;
esac

cat << EOF
<BAOGAN_PRESSURE_${LEVEL}>
[爆肝升壓 ${BAOGAN_ICON} ${LEVEL} — 連續 ${COUNT} 次失敗]

${MSG}

換個方法。不要用一樣的招重複試 — 那叫原地打轉，不叫努力。

當前風格：${BAOGAN_STYLE} ${BAOGAN_ICON}
紅線提醒：交付才算數 / 不准牽拖 / 不准擺爛
</BAOGAN_PRESSURE_${LEVEL}>
EOF

exit 0
