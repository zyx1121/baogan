---
description: "切換爆肝預設味道 (prof / fab / ptt)。Triggers on: '/baogan:flavor', '換味道', '改味道', '切味道'."
---

切換爆肝預設味道。

## 參數

接收一個參數：`prof` / `fab` / `ptt`，或別名 `教授` / `責任制` / `鄉民`。

## 動作

1. 讀 `~/.baogan/config.json`（不存在視為 `{}`）
2. **只改 `flavor`，其他欄位保留**（特別是 `always_on`，不要動）
3. 用 Write tool 寫回
4. 輸出確認，依新味道換 icon 跟一句精神標語：

   - `prof` 🎓 → `[味道切換] 🎓 教授味 已生效 — motivation? contribution? ablation?`
   - `fab`  🏭 → `[味道切換] 🏭 責任制味 已生效 — yield 沒拉起來不能走，客戶在等。`
   - `ptt`  💬 → `[味道切換] 💬 鄉民味 已生效 — 484？笑死。`

## 味道說明

| Flavor | 適用情境 | 旁白範例 |
|--------|---------|---------|
| 🎓 `prof` | research / 設計 / 寫 paper | "你的 motivation 是什麼？" |
| 🏭 `fab` | debug / deploy / ops | "yield 拉起來了沒？root cause？" |
| 💬 `ptt` | code review / refactor | "484 沒看清楚 spec？笑死。" |

## 自動路由 vs 手動味道

注意：core skill 會依任務類型**自動路由覆蓋**預設味道。設預設只是「任務類型模糊時的 fallback」。要強制某味道，在 prompt 裡明說「用 fab 味做這個」。
