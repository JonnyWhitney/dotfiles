-- Builtin Monitor
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "2",
})
-- Home Widescreen Monitor
hl.monitor({
	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD.",
	mode = "3440x1440@144.00Hz",
	position = "auto-left",
	scale = "1",
})

-- Home TV
hl.monitor({
	output = "desc:Samsung Electric Company SAMSUNG",
	mode = "3840x2160@30.00Hz",
	position = "auto-left",
	scale = "2",
})
-- Default Quick Plug
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-left",
	scale = "2",
})

-- Workspaces
hl.workspace_rule({
	workspace = "1",
	monitor = "eDP-1",
	default = true,
})
hl.workspace_rule({
	workspace = "2",
	monitor = "eDP-1",
})
hl.workspace_rule({
	workspace = "3",
	monitor = "eDP-1",
})
hl.workspace_rule({
	workspace = "4",
	monitor = "eDP-1",
})
