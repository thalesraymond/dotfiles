## 2024-05-23 - Waybar Polling Madness
**Learning:** Default Waybar configs often poll CPU/Network every 1s. This keeps the CPU awake and wastes battery/cycles for data that doesn't change meaningfully that fast.
**Action:** Audit polling intervals in status bars. Increase to 5s+ for non-critical metrics.
