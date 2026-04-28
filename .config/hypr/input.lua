hl.config({
	input = {
		repeat_rate = 100,
		repeat_delay = 350,

		sensitivity = 0.5,
		accel_profile = "flat",
		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			clickfinger_behavior = true,
			tap_to_click = false,
		},
	},
})
hl.device({
	name = "elan0686:00-04f3:320d-touchpad",
	sensitivity = 1,
})
hl.device({
	name = "tpps/2-elan-trackpoint",
	sensitivity = 0.5,
})

hl.config({
	gestures = { workspace_swipe_forever = true },
})
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
