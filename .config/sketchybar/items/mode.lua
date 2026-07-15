local colors = require("colors")

local mode_names = {
	main = "Main",
	["layout-move"] = "Move",
	resize = "Resize",
}

local mode_colors = {
	main = colors.fg,
	["layout-move"] = colors.warning,
	resize = colors.resize,
}

local mode = Sbar.add("item", "aerospace.mode", {
	position = "right",
	icon = { drawing = false },
	label = { string = "Submap: Main" },
})

local function update_mode(mode_name)
	if not mode_name or mode_name == "" then
		return
	end

	mode:set({
		label = {
			string = "Submap: " .. (mode_names[mode_name] or mode_name),
			color = mode_colors[mode_name] or colors.fg,
		},
	})
end

mode:subscribe("aerospace_mode_change", function(env)
	update_mode(env.MODE)
end)

Sbar.exec("aerospace list-modes --current", function(current_mode)
	if type(current_mode) == "string" then
		update_mode(current_mode:match("^%s*(.-)%s*$"))
	end
end)

Sbar.exec("~/.config/sketchybar/helpers/aerospace_mode.sh >/dev/null 2>&1 &")
