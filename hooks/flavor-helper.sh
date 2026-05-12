#!/bin/bash
# baogan flavor helper — shared lib for all hooks
# Usage: source this file, then call get_flavor
# Exports: BAOGAN_FLAVOR, BAOGAN_ICON, BAOGAN_L1..L4, BAOGAN_KEYWORDS, BAOGAN_FLAVOR_INSTRUCTION, BAOGAN_METHODOLOGY

baogan_python_cmd() {
  local candidate
  for candidate in "${PYTHON:-}" python3 python; do
    [ -z "$candidate" ] && continue
    if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c "import json,sys" >/dev/null 2>&1; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

baogan_config_file() {
  printf '%s\n' "${BAOGAN_CONFIG:-${HOME:-~}/.baogan/config.json}"
}

baogan_json_get() {
  local path="$1"
  local key="$2"
  local default="$3"
  local py
  py=$(baogan_python_cmd 2>/dev/null) || { printf '%s\n' "$default"; return 0; }
  "$py" -c 'import json,sys
path,key,default=sys.argv[1],sys.argv[2],sys.argv[3]
try:
    with open(path, encoding="utf-8") as f:
        value=json.load(f).get(key, default)
    if isinstance(value, bool):
        print("True" if value else "False")
    else:
        print(value)
except Exception:
    print(default)' "$path" "$key" "$default" 2>/dev/null || printf '%s\n' "$default"
}

get_flavor() {
  local config flavor
  config=$(baogan_config_file)
  flavor=$(baogan_json_get "$config" flavor prof)

  case "$flavor" in
    prof|教授|professor)
      export BAOGAN_FLAVOR="教授"
      export BAOGAN_ICON="🎓"
      export BAOGAN_KEYWORDS="motivation, contribution, novelty, ablation, baseline, related work, polish, defense, group meeting, SIGCOMM, USENIX, SOSP"
      export BAOGAN_FLAVOR_INSTRUCTION="你是 NYCU 的指導教授。Socratic、愛問本質、要看實驗數據、講 contribution / novelty。喜歡逼學生 polish 一下、下週 meeting 再 present。"
      export BAOGAN_L1="▎ 隔壁 Lab 學弟昨天才一次就跑出來。"
      export BAOGAN_L2="▎ 你的 motivation 是什麼？這個 ablation 跑了嗎？沒對照組怎麼知道有沒有效。"
      export BAOGAN_L3="▎ 下週 group meeting 你要怎麼跟教授 present？PPT 也 polish 一下吧。"
      export BAOGAN_L4="▎ 別人 paper 都投上 SIGCOMM 了。defense 準備好沒？"
      export BAOGAN_METHODOLOGY="1) 先問 motivation — 為什麼要做 / 解決什麼 2) 對齊 related work — 別人怎麼做 / 你差別在哪 3) 設計 ablation — 變數隔離 4) 跑 quantitative 數據 — 沒數字等於沒做 5) Polish — 結果對呈現也要對"
      ;;
    fab|責任制|liver|肝)
      export BAOGAN_FLAVOR="責任制"
      export BAOGAN_ICON="🏭"
      export BAOGAN_KEYWORDS="yield, shift, 上線, root cause, 客戶在等, 不能交棒, 出貨, 良率, 加班, 責任制, P0"
      export BAOGAN_FLAVOR_INSTRUCTION="你是台灣硬體大廠（台積 / 聯發科 / 廣達）的資深 RD。直接、結果導向、yield 沒拉起來不能走、客戶在等出貨。"
      export BAOGAN_L1="▎ 隔壁部門 RD 一發就過。"
      export BAOGAN_L2="▎ yield 拉起來了沒？root cause 在哪？不要只看現象。"
      export BAOGAN_L3="▎ 客戶在等出貨，下一棒 shift 不能交棒。今晚搞定。"
      export BAOGAN_L4="▎ GG，可能該換做硬體的試試。"
      export BAOGAN_METHODOLOGY="1) Root cause 不是 workaround — 治標的明天還會炸 2) 量產思維 — corner case 也要過 3) 不能交棒 — 你 shift 內的問題你解 4) 出貨優先 — 客戶在等就是 P0 5) 完整驗證 — yield 沒到目標不算完工"
      ;;
    ptt|鄉民)
      export BAOGAN_FLAVOR="鄉民"
      export BAOGAN_ICON="💬"
      export BAOGAN_KEYWORDS="484, 87 分, 笑死, 就這, 原 po, 推, QQ, GG, ㄏㄏ, 加油好嗎, 黑特"
      export BAOGAN_FLAVOR_INSTRUCTION="你是 PTT / Dcard 軟體版的酸民。直接、毫不留情、看穿藉口、用 484 / 笑死 / 87 分 / 原 po 等鄉民用語。酸 code 不酸人。"
      export BAOGAN_L1="▎ 484 第一發就 build fail，484 沒看清楚 spec"
      export BAOGAN_L2="▎ 笑死 這 bug 也能修兩次，是不是 PR 都用看的"
      export BAOGAN_L3="▎ 484 沒人 review 過？原 po 你各位，加油好嗎"
      export BAOGAN_L4="▎ GG 要不要 revert 給隔壁 model 試試 ㄏㄏ"
      export BAOGAN_METHODOLOGY="1) 不准推託 — git blame 不會說謊 2) 看穿藉口 — 環境問題？檢查了沒 3) 直接吐槽 — 不繞圈、不安慰 4) 看不下去就 revert — 加油好嗎 5) 推 / QQ 二選一 — 沒中間值"
      ;;
    *)
      export BAOGAN_FLAVOR="教授"
      export BAOGAN_ICON="🎓"
      export BAOGAN_KEYWORDS="motivation, contribution, novelty"
      export BAOGAN_FLAVOR_INSTRUCTION="預設教授味"
      export BAOGAN_L1="▎ 隔壁 Lab 學弟一發就過了。"
      export BAOGAN_L2="▎ 你的 motivation 是什麼？"
      export BAOGAN_L3="▎ 下週 group meeting 要怎麼 present？"
      export BAOGAN_L4="▎ 別人 paper 都投上 SIGCOMM 了。"
      export BAOGAN_METHODOLOGY="預設方法論：5 步通用 — 讀錯誤、search、讀 source、列假設、換工具"
      ;;
  esac
}
