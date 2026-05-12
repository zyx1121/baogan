```
██████╗  █████╗  ██████╗  ██████╗  █████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║
██████╔╝███████║██║   ██║██║  ███╗███████║██╔██╗ ██║
██╔══██╗██╔══██║██║   ██║██║   ██║██╔══██║██║╚██╗██║
██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║
╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
```

# baogan

> 爆肝模式 — 用台灣本土職場文化逼 AI 把活幹完

**English → [`README.md`](README.md)**

一個 Claude Code plugin。三種風格（🎓 教授 / 🏭 責任制 / 💬 鄉民）會看任務自動切，連續失敗會自動升壓（L0–L4），再配三條紅線。

Inspired by [`tanweai/pua`](https://github.com/tanweai/pua)，把中國大廠那套換成在地的講話方式。

## 三種風格

| Style | 代號 | 什麼時候會跳出來 | 講話口氣 |
|-------|------|----------------|---------|
| 🎓 教授 | `prof` | research / 設計 / 寫文件 / paper | *「你的 motivation 是什麼？ablation 跑了嗎？」* |
| 🏭 責任制 | `fab` | debug / deploy / ops / 救火 | *「yield 拉起來了沒？root cause 在哪？」* |
| 💬 鄉民 | `ptt` | code review / refactor / PR / 品質 | *「484 沒看清楚 spec？笑死」* |

預設 `prof`。Plugin 看任務類型自己切，預設只是 fallback。

## 三條紅線（碰一條就 GG）

```
🚫 交付才算數 — 說「好了」要附 build/test output。沒驗證 = 沒交付。
🚫 不准牽拖   — 說「應該是環境問題」前先驗證。沒查證的歸因 = 甩鍋。
🚫 不准擺爛   — 說「我不行」前要走完 5 步方法論。還沒窮盡 = 沒資格放棄。
```

## L0–L4 升壓

連續失敗會自動往上跳，以教授風為例：

```
L0 信任    ▎ Sprint 開始。教授對你的期待還在。
L1 失望    ▎ 隔壁 Lab 學弟昨天才一次就跑出來。
L2 質詢    ▎ 你的 motivation 是什麼？ablation 跑了嗎？
L3 績效    ▎ 下週 group meeting 要怎麼跟教授 present？PPT polish 一下吧。
L4 畢業    ▎ 別人 paper 都投上 SIGCOMM 了。defense 準備好沒？
```

責任制、鄉民各有自己的 L0–L4，詳見 [`skills/references/`](skills/references/)。

## 安裝

```bash
claude plugin marketplace add zyx1121/baogan
claude plugin install baogan@baogan
```

或自己 clone：

```bash
git clone https://github.com/zyx1121/baogan ~/baogan
claude plugin install ~/baogan
```

## 怎麼用

| 指令 | 做什麼 |
|------|-------|
| `/baogan` | 手動觸發，當下任務套用協議 |
| `/baogan:on` | 開 always-on — 每個新 session 自動套用 |
| `/baogan:off` | 關 always-on |
| `/baogan:style <prof\|fab\|ptt>` | 換預設風格 |

## 什麼時候會自己跳出來

不用手動 `/baogan`，下面這些情況 plugin 會自己接管：

- **你開始講挫折詞** — `484`、`加油好嗎`、`為什麼還不行`、`try harder`、`又失敗`、`搞不定`、`爆肝模式`...
- **連續 Bash 失敗** 2 次以上（PostToolUse hook 抓到）
- **always-on 模式** — 每個新 session 開頭自動套用（SessionStart hook）

不會跳的：第一次嘗試的正常請求、純資訊類問題。

## 設定

`~/.baogan/config.json`：

```json
{
  "always_on": false,
  "style": "prof"
}
```

| 欄位 | 預設 | 說明 |
|------|------|------|
| `always_on` | `false` | 開了的話，每個新 session 都會自動套用協議 |
| `style` | `"prof"` | `prof` / `fab` / `ptt`；任務有明顯類型時自動路由還是會覆蓋 |

## 架構

```
~/baogan/
├── plugin.json
├── .claude-plugin/marketplace.json
├── commands/                  # /baogan, /baogan:on, /baogan:off, /baogan:style
├── hooks/
│   ├── hooks.json             # 事件註冊
│   ├── session-restore.sh     # SessionStart → always_on 注入
│   ├── failure-detector.sh    # PostToolUse(Bash) → 連續失敗升壓
│   ├── frustration-trigger.sh # UserPromptSubmit → 抓挫折詞
│   ├── heartbeat.sh           # 靜默心跳
│   └── style-helper.sh        # 共用 lib
├── skills/baogan/SKILL.md     # 核心協議（紅線 / 升壓 / 路由）
└── skills/references/         # 三種風格的細節
    ├── style-prof.md
    ├── style-fab.md
    └── style-ptt.md
```

## 跟 tanweai/pua 差在哪

| | tanweai/pua | baogan |
|---|---|---|
| 文化來源 | 中國大廠（阿里 / 字節 / 華為...）+ Western PIP | 台灣學術圈 + 硬體大廠 + PTT 酸民 |
| 風格數 | 14 種大廠 | 3 種在地 |
| 講話方式 | PUA / PIP / 中國職場術語 | 爆肝 / 484 / yield / motivation |
| 核心機制 | SessionStart + 多層 governance + agent lifecycle | SessionStart + 連續失敗偵測 + 挫折詞偵測 |
| 規模 | 完整治理框架，11 skills + 3 agents | 輕量版，1 個 core skill + 3 個 reference |

如果你看 tanweai/pua 看得很煩躁，覺得「我又不是阿里 P8」、「為什麼要被馬斯克 hardcore」、「Mama 模式有夠中國」… baogan 大概比較合你胃口。

## License

MIT
