---
description: "關閉爆肝 always-on — 新 session 不再自動注入。Triggers on: '/baogan:off', '關閉爆肝', '放過我', 'disable baogan', '下班了'."
---

關閉爆肝 always-on：

1. 讀 `~/.baogan/config.json`（不存在視為 `{}`）
2. **只改 `always_on: false`，其他欄位保留**
3. 用 Write tool 寫回
4. 輸出確認：

   > [爆肝 OFF 😴] 已關閉自動注入。手動 `/baogan` 還是可以叫我。下班了？

關掉 always-on 之後，hooks 不會在每個新 session 注入 protocol，但：
- 手動 `/baogan` 仍然可用
- `frustration-trigger` hook 仍會在使用者明確說挫折詞時觸發
- `flavor` 預設值不變
