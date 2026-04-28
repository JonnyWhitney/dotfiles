hl.window_rule({
	name = "firefox-pip",
	match = {
		class = "firefox-nightly",
		title = "Picture-in-Picture",
	},

	float = true,
	pin = true,
	size = "320 180",
	move = "4 (monitor_h-window_h-4)",
	no_initial_focus = true,
	content = "video",
})
