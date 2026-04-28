local uwsm_prefix = "uwsm app -- "
hl.on("hyprland.start", function()
	hl.exec_cmd(uwsm_prefix .. "udiskie &")
	hl.exec_cmd(uwsm_prefix .. "wl-paste --type image --watch cliphist store")
	hl.exec_cmd(uwsm_prefix .. "wl-paste --type text --watch cliphist store")
	hl.exec_cmd(uwsm_prefix .. "dunst")
end)
