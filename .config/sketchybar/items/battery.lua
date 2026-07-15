local battery = Sbar.add("item", "battery", {
	position = "right",
	update_freq = 120,
})

local function update_battery()
	Sbar.exec("pmset -g batt", function(result)
		local pct = result:match("(%d+)%%")
		if not pct then
			return
		end
		local n = tonumber(pct)
		local charging = result:match("AC Power") ~= nil

		local icon
		if charging then
			icon = ""
		elseif n >= 90 then
			icon = ""
		elseif n >= 60 then
			icon = ""
		elseif n >= 30 then
			icon = ""
		elseif n >= 10 then
			icon = ""
		else
			icon = ""
		end

		battery:set({
			icon = { string = icon },
			label = { string = pct .. "%" },
		})
	end)
end

battery:subscribe({
	"routine",
	"system_woke",
	"power_source_change",
}, update_battery)
