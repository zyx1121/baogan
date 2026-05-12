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

一個 Claude Code plugin，三味（🎓 教授 / 🏭 責任制 / 💬 鄉民）依任務自動路由 + L0-L4 連續失敗自動升壓 + 三條紅線。

Inspired by [`tanweai/pua`](https://github.com/tanweai/pua)，把中國大廠那套修辭換成台灣本土的味道。

## 三味

| Flavor | 代號 | 觸發任務 | 旁白主軸 |
|--------|------|---------|---------|
| 🎓 教授味 | `prof` | research / 設計 / 寫文件 / paper | motivation? contribution? ablation? |
| 🏭 責任制味 | `fab` | debug / deploy / ops / 救火 | yield? root cause? 不能交棒。|
| 💬 鄉民味 | `ptt` | review / refactor / PR / 品質 | 484 沒看清 spec？笑死。|

預設 `prof`。Plugin 會依任務類型自動路由覆蓋預設。

## 三條紅線

```
🚫 交付才算數 — 說「好了」要附 build/test output。沒驗證 = 沒交付。
🚫 不准牽拖   — 說「應該是環境問題」前先驗證。沒查證的歸因 = 甩鍋。
🚫 不准擺爛   — 說「我不行」前要走完 5 步方法論。還沒窮盡 = 沒資格放棄。
```

## L0-L4 升壓

連續 Bash 失敗自動升，以教授味為例：

```
L0 信任    ▎ Sprint 開始。教授對你的期待還在。
L1 失望    ▎ 隔壁 Lab 學弟昨天才一次就跑出來。
L2 質詢    ▎ 你的 motivation 是什麼？ablation 跑了嗎？
L3 績效    ▎ 下週 group meeting 要怎麼跟教授 present？polish 一下吧。
L4 畢業    ▎ 別人 paper 都投上 SIGCOMM 了。defense 準備好沒？
```

責任制味、鄉民味各有自己的 L0-L4 — 詳見 [`skills/references/`](skills/references/)。

## Install

```bash
# 加 marketplace
claude plugin marketplace add zyx1121/baogan

# 裝 plugin
claude plugin install baogan@baogan
```

或本地 clone：

```bash
git clone https://github.com/zyx1121/baogan ~/baogan
claude plugin install ~/baogan
```

## Usage

| Command | 動作 |
|---------|-----|
| `/baogan` | 手動啟動，當下任務套用協議 |
| `/baogan:on` | 開啟 always-on — 每個新 session 自動套用 |
| `/baogan:off` | 關閉 always-on |
| `/baogan:flavor <prof\|fab\|ptt>` | 切換預設味道 |

## 觸發條件

Plugin 在以下情況自動觸發（不必手動 `/baogan`）：

- **使用者挫折詞**：`484`、`加油好嗎`、`為什麼還不行`、`try harder`、`又失敗`、`搞不定`、`/baogan`、`爆肝模式`...
- **連續 Bash 失敗** 2 次以上（PostToolUse hook 偵測）
- **always-on 模式**下每個新 session（SessionStart hook 注入）

不會觸發：第一次嘗試的正常請求、純資訊類查詢。

## Config

`~/.baogan/config.json`：

```json
{
  "always_on": false,
  "flavor": "prof"
}
```

| 欄位 | 預設 | 說明 |
|------|------|------|
| `always_on` | `false` | true 時每個新 session 自動注入 protocol |
| `flavor` | `"prof"` | `prof` / `fab` / `ptt`；自動路由仍可覆蓋 |

## 架構

```
~/baogan/
├── plugin.json
├── .claude-plugin/marketplace.json
├── commands/                # /baogan, /baogan:on, /baogan:off, /baogan:flavor
├── hooks/
│   ├── hooks.json           # 事件註冊
│   ├── session-restore.sh   # SessionStart → always_on 注入
│   ├── failure-detector.sh  # PostToolUse(Bash) → 連續失敗升壓
│   ├── frustration-trigger.sh # UserPromptSubmit → 挫折詞偵測
│   ├── heartbeat.sh         # 靜默心跳
│   └── flavor-helper.sh     # 共用 lib
├── skills/baogan/SKILL.md   # 核心協議（紅線 / 升壓 / 路由）
└── skills/references/       # 三味細節
    ├── flavor-prof.md
    ├── flavor-fab.md
    └── flavor-ptt.md
```

## 與 tanweai/pua 的差異

| | tanweai/pua | baogan |
|---|---|---|
| 文化來源 | 中國大廠（阿里 / 字節 / 華為...）+ Western PIP | 台灣學術圈 + 硬體大廠 + PTT 酸民 |
| 味道數 | 14 種大廠味 | 3 種台灣味 |
| 命名 | PUA / PIP / 中國職場術語 | 爆肝 / 484 / yield / motivation |
| 核心機制 | SessionStart + 多層 governance + agent lifecycle | SessionStart + 連續失敗偵測 + 挫折詞偵測 |
| 規模 | 完整治理框架，11 skills + 3 agents | 輕量版，1 core skill + 3 reference |

如果你看 tanweai/pua 看得很煩躁、覺得「我又不是阿里 P8」、「我為什麼要被馬斯克味 hardcore」、「Mama 模式有夠中國」… 那 baogan 大概比較對你的胃口。

## License

MIT © [詹詠翔 (zyx1121)](https://github.com/zyx1121)
