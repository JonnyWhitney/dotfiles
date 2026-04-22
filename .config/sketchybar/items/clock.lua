local clock = Sbar.add("item", "clock", {
	position = "right",
	icon = { string = "" },
	update_freq = 1,
})

clock:subscribe("routine", function(_)
	Sbar.exec("date '+%m/%d %r'", function(result)
		clock:set({ label = { string = result:gsub("%s+$", "") } })
	end)
end)
