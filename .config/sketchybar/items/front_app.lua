local front_app = Sbar.add("item", "front_app", {
	position = "left",
	icon = { drawing = false },
	label = { padding_left = 8 },
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)
