-- DMS Window Rules — managed by Dux Modular Shell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=dms-window-opaque, name=DMS Window Opaque
hl.window_rule({ match = { class = "^(dev\\.duxlabs\\.shell|com\\.danklinux\\.dms)$" }, opaque = true })
