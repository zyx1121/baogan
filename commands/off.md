---
description: "關閉爆肝 always-on — 新 session 不再自動套用。Triggers on: '/baogan:off', '關閉爆肝', '放過我', 'disable baogan', '下班了'."
---

關閉爆肝 always-on：

1. 讀 `~/.baogan/config.json`（不存在視為 `{}`）
2. **只改 `always_on: false`，其他欄位保留**
3. 用 Write tool 寫回
4. 輸出確認：

   > [爆肝 OFF 😴] 已關掉自動套用。手動 `/baogan` 還是可以叫我。下班了？

關掉 always-on 之後，hooks 不會每個新 session 自動套協議，但：
- 手動 `/baogan` 還是可以用
- `frustration-trigger` hook 偵測到使用者挫折詞還是會觸發
- `style` 預設值不動
