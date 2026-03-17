-- keymaps.lua
-- Replicates Karabiner-Elements key remapping in Hammerspoon

-- Full exclusion list (terminals + remote desktop apps)
local STANDARD_EXCLUDED = {
	"com.microsoft.rdc",
	"com.microsoft.rdc.mac",
	"com.microsoft.rdc.macos",
	"com.microsoft.rdc.osx.beta",
	"net.sf.cord",
	"com.thinomenon.RemoteDesktopConnection",
	"com.itap-mobile.qmote",
	"com.nulana.remotixmac",
	"com.p5sys.jump.mac.viewer",
	"com.p5sys.jump.mac.viewer.web",
	"com.teamviewer.TeamViewer",
	"com.vmware.horizon",
	"com.2X.Client.Mac",
	"com.vmware.fusion",
	"com.vmware.view",
	"com.parallels.desktop",
	"com.parallels.vm",
	"com.parallels.desktop.console",
	"org.virtualbox.app.VirtualBoxVM",
	"com.citrix.XenAppViewer",
	-- prefix matches handled in isInList:
	"com.vmware.proxyApp.",
	"com.parallels.winapp.",
	-- terminal emulators:
	"tv.parsec.www",
	"org.macports.X11",
	"com.apple.Terminal",
	"com.googlecode.iterm2",
	"co.zeit.hyperterm",
	"co.zeit.hyper",
	"org.alacritty",
	"net.kovidgoyal.kitty",
	"com.github.wez.wezterm",
	"com.mitchellh.ghostty",
}

-- Smaller exclusion list (terminal emulators only)
local TERMINAL_EXCLUDED = {
	"org.macports.X11",
	"com.apple.Terminal",
	"com.googlecode.iterm2",
	"co.zeit.hyper",
	"org.virtualbox.app.VirtualBoxVM",
	"com.microsoft.rdc.macos",
	"tv.parsec.www",
	"com.mitchellh.ghostty",
}

-- Browser bundle IDs
local BROWSERS = {
	"org.mozilla.firefox",
	"org.mozilla.firefoxdeveloperedition",
	"org.mozilla.nightly",
	"com.google.Chrome",
	"com.brave.Browser",
	"com.apple.Safari",
	-- prefix match handled in isInList:
	"com.microsoft.Edge",
}

-- Check if bundleID is in a list (supports prefix matching for entries ending in ".")
local function isInList(bundleID, list)
	for _, entry in ipairs(list) do
		if entry:sub(-1) == "." then
			-- prefix match
			if bundleID:sub(1, #entry) == entry then
				return true
			end
		elseif entry:sub(-4) ~= "Edge" and bundleID == entry then
			return true
		elseif entry == "com.microsoft.Edge" then
			-- prefix match for Edge variants (e.g. com.microsoft.Edge, com.microsoft.Edge.Dev)
			if bundleID == entry or bundleID:sub(1, #entry + 1) == entry .. "." then
				return true
			end
		else
			if bundleID == entry then
				return true
			end
		end
	end
	return false
end

-- Keys for standard Ctrl→Cmd remap
local STANDARD_KEYS = {
	[hs.keycodes.map["c"]] = true,
	[hs.keycodes.map["v"]] = true,
	[hs.keycodes.map["x"]] = true,
	[hs.keycodes.map["z"]] = true,
	[hs.keycodes.map["a"]] = true,
	[hs.keycodes.map["s"]] = true,
	[hs.keycodes.map["n"]] = true,
	[hs.keycodes.map["f"]] = true,
	[hs.keycodes.map["g"]] = true,
	[hs.keycodes.map["w"]] = true,
}

-- Keys for terminal-excluded-only Ctrl→Cmd remap
local TERMINAL_KEYS = {
	[hs.keycodes.map["t"]] = true,
	[hs.keycodes.map["b"]] = true,
	[hs.keycodes.map["i"]] = true,
}

-- Key event tap: handle Ctrl+key remaps
local keyEventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
	local flags = e:getFlags()
	if not flags.ctrl then
		return false
	end

	local kc = e:getKeyCode()
	local bundleID = (hs.application.frontmostApplication() or {
		bundleID = function()
			return ""
		end,
	}):bundleID() or ""

	-- Ctrl+Y → Cmd+Shift+Z (Redo)
	if kc == hs.keycodes.map["y"] and not isInList(bundleID, STANDARD_EXCLUDED) then
		hs.eventtap.keyStroke({ "cmd", "shift" }, "z", 0)
		return true
	end

	-- Standard Ctrl→Cmd remaps (flag mutation, same key code)
	if STANDARD_KEYS[kc] and not isInList(bundleID, STANDARD_EXCLUDED) then
		flags.ctrl = false
		flags.cmd = true
		e:setFlags(flags)
		return false
	end

	-- Ctrl+Shift+I → Cmd+Opt+I in Firefox (open dev console)
	if
		kc == hs.keycodes.map["i"]
		and flags.shift
		and (
			bundleID == "org.mozilla.firefox"
			or bundleID == "org.mozilla.firefoxdeveloperedition"
			or bundleID == "org.mozilla.nightly"
		)
	then
		hs.eventtap.keyStroke({ "cmd", "alt" }, "i", 0)
		return true
	end

	-- Ctrl+T/B/I → Cmd+T/B/I (smaller exclusion list)
	if TERMINAL_KEYS[kc] and not isInList(bundleID, TERMINAL_EXCLUDED) then
		flags.ctrl = false
		flags.cmd = true
		e:setFlags(flags)
		return false
	end

	-- Ctrl+R → Cmd+R (browsers only)
	if kc == hs.keycodes.map["r"] and isInList(bundleID, BROWSERS) then
		flags.ctrl = false
		flags.cmd = true
		e:setFlags(flags)
		return false
	end

	return false
end)

-- Mouse event tap: Ctrl+Left Click → Cmd+Left Click
local mouseEventtap = hs.eventtap.new(
	{ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.leftMouseUp },
	function(e)
		local flags = e:getFlags()
		if flags.ctrl and not flags.cmd then
			flags.ctrl = false
			flags.cmd = true
			e:setFlags(flags)
		end
		return false
	end
)

-- Opt+D → Cmd+L in browsers (focus address bar)
hs.hotkey.bind({ "alt" }, "d", function()
	local bundleID = (hs.application.frontmostApplication() or {
		bundleID = function()
			return ""
		end,
	}):bundleID() or ""
	if isInList(bundleID, BROWSERS) then
		hs.eventtap.keyStroke({ "cmd" }, "l", 0)
	else
		hs.eventtap.keyStroke({ "alt" }, "d", 0)
	end
end)

-- Disable Cmd+H (hide application), Cmd+Option+H (hide others), Cmd+Option+M (minimize all)
hs.hotkey.bind({ "cmd" }, "h", function() end)
hs.hotkey.bind({ "cmd", "alt" }, "h", function() end)
hs.hotkey.bind({ "cmd", "alt" }, "m", function() end)

-- Start event taps
keyEventtap:start()
mouseEventtap:start()

-- Watchdog: macOS can silently disable event taps (e.g. after sleep/wake).
-- Check every 5 seconds and restart if needed.
local watchdogTimer = hs.timer.new(5, function()
	if not keyEventtap:isEnabled() then
		keyEventtap:start()
	end
	if not mouseEventtap:isEnabled() then
		mouseEventtap:start()
	end
end)
watchdogTimer:start()

-- Also restart explicitly on wake from sleep
local caffeinateWatcher = hs.caffeinate.watcher.new(function(event)
	if event == hs.caffeinate.watcher.systemDidWake or event == hs.caffeinate.watcher.screensDidWake then
		keyEventtap:start()
		mouseEventtap:start()
	end
end)
caffeinateWatcher:start()

print("keymaps loaded")
