local mainMod = "SUPER"

hl.bind(mainMod .. " + f", hl.dsp.exec_cmd("uwsm app -- foot -e zellij"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("uwsm app -- foot"))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("uwsm app -- hyprlauncher"))
hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp -o -r )" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date "+%Y%m%d-%H:%M:%S").png'
	)
)

hl.bind(mainMod .. "+ SHIFT + Y", hl.dsp.window.kill())
hl.bind(mainMod .. "+ SHIFT + Q", hl.dsp.exec_cmd("loginctl terminate-user ''"))
hl.bind(
	mainMod .. "+ SHIFT + v",
	hl.dsp.exec_cmd("uwsm app -- cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")
)

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(mainMod .. " + tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.window.cycle_next({ action = "prev" }))

hl.bind(mainMod .. " + ALT + h", hl.dsp.layout("orientationleft"))
hl.bind(mainMod .. " + ALT + j", hl.dsp.layout("orientationbottom"))
hl.bind(mainMod .. " + ALT + k", hl.dsp.layout("orientationtop"))
hl.bind(mainMod .. " + ALT + l", hl.dsp.layout("orientationright"))

hl.bind(mainMod .. " + p", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + o", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + u", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + i", hl.dsp.layout("removemaster"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + c", hl.dsp.window.pin())

hl.bind(mainMod .. "+ r", hl.dsp.submap("Resize"))
hl.define_submap("Resize", function()
	hl.bind("r", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg mfact exact 0.66"))
	hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. "+ t", hl.dsp.submap("Move"))
hl.define_submap("Move", function()
	hl.bind("l", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })
	hl.bind("catchall", hl.dsp.submap("reset"))
end)
