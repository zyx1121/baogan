---
description: "開啟爆肝 always-on — 每個新 session 自動套用協議。Triggers on: '/baogan:on', '開啟爆肝', '一直爆肝', 'enable baogan', '我要爆肝'."
---

開啟爆肝 always-on：

1. 確保 `~/.baogan/` 目錄存在（不存在就 `mkdir -p`）
2. 讀現有 `~/.baogan/config.json`（不存在視為 `{}`），**只改 `always_on: true`，不要動到其他欄位**
   - 若 `style` 不存在，預設為 `"prof"`
   - 其他欄位保留原樣
3. 用 Write tool 寫回完整 JSON
4. 輸出確認：

   > [爆肝 ON 🔥] 從現在起每個新 session 都自動進入爆肝模式。沒結果就是空話。

## 對稱性（與 `/baogan:off` 的關係）

- `/baogan:off` 把 `always_on` 設為 `false`，但保留 `style` 等其他欄位
- `/baogan:on` **一定要**保留其他欄位，不要整份 config 蓋掉
- 不清楚的欄位一律保留，不要丟掉
