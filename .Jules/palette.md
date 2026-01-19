## 2025-02-18 - [Misleading Tooltips in Config Files]
**Learning:** Configuration files for desktop environments (like Waybar) often duplicate logic in tooltips (text description) vs actions (commands), leading to desynchronization. Always verify that `tooltip-format` matches `on-click-*` handlers.
**Action:** When auditing config files, cross-reference user-facing text strings with the actual commands they describe.
