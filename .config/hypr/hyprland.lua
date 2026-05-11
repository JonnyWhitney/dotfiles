hl.config({
	general = {
		border_size = 4,
		gaps_in = 2,
		gaps_out = 2,
		float_gaps = 2,
		col = {
			active_border = "rgba(00ffffff)",
			inactive_border = "rgba(888888ff)",
		},
		layout = "master",
		snap = {
			enabled = true,
			respect_gaps = true,
		},
	},

	decoration = {
		rounding = 4,
		blur = { enabled = false },
		shadow = { enabled = false },
	},

	animations = {
		enabled = false,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		font_family = "CommitMono Nerd Font Mono",
	},

	master = {
		allow_small_split = true,
		orientation = "right",
		mfact = 0.66,
	},

	debug = {
		disable_logs = false,
	},
})

require("perms")
require("monitors")
require("input")
require("binds")
require("windows")
require("startup")
