local colors = require("colors")

local claude = Sbar.add("item", "claude", {
	position = "right",
	update_freq = 180,
	icon = { string = "✳" },
})

-- Ranks a limit's severity so the label can take the worst across all limits.
-- Severity strings from the API take precedence; percent thresholds cover
-- values the API still reports as "normal".
local function severity_rank(limit)
	local severity = limit.severity or "normal"
	local percent = limit.percent or 0
	if severity == "critical" or severity == "exceeded" or percent >= 90 then
		return 2
	elseif severity == "warning" or severity == "elevated" or percent >= 70 then
		return 1
	end
	return 0
end

local rank_colors = {
	[0] = colors.fg,
	[1] = colors.warning,
	[2] = colors.critical,
}

local script = os.getenv("HOME") .. "/.config/sketchybar/helpers/claude_usage.sh"

local function update_claude()
	Sbar.exec(script, function(result)
		if type(result) ~= "table" or result.error or type(result.limits) ~= "table" or #result.limits == 0 then
			claude:set({ label = { string = "–", color = colors.dim } })
			return
		end

		local parts = {}
		local worst = 0
		for _, limit in ipairs(result.limits) do
			table.insert(parts, math.floor(limit.percent or 0) .. "%")
			worst = math.max(worst, severity_rank(limit))
		end

		claude:set({
			label = {
				string = table.concat(parts, " · "),
				color = rank_colors[worst],
			},
		})
	end)
end

claude:subscribe({
	"routine",
	"system_woke",
}, update_claude)

update_claude()
