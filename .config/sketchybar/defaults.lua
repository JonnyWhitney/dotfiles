local colors = require("colors")
local settings = require("settings")

Sbar.default({
	icon = {
		font = settings.font,
		color = colors.fg,
		padding_left = 8,
		padding_right = 4,
	},
	label = {
		font = settings.font,
		color = colors.fg,
		padding_left = 4,
		padding_right = 8,
	},
	background = {
		color = colors.bg,
		border_color = colors.border,
		corner_radius = 5,
		border_width = 2,
		height = 26,
		drawing = true,
	},
	padding_left = 4,
	padding_right = 4,
})
