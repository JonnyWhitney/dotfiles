-- keymaps.lua
-- Windows-style shortcuts on macOS: a Ctrl chord becomes the equivalent Cmd
-- chord, except in applications that need the raw Ctrl key.
--
-- AeroSpace binds every one of its commands to a ctrl-cmd-alt chord. Each rule
-- here applies only when Ctrl is held without Cmd or Alt, so the window manager
-- keeps its keymap.

local M = {}
local log = hs.logger.new("keymaps", "info")

M.enabled = true

--------------------------------------------------------------------------------
-- Application lists
--------------------------------------------------------------------------------

-- Return a new list that holds the entries of each given list, in order.
local function concat(...)
	local out = {}
	for _, list in ipairs({ ... }) do
		for _, entry in ipairs(list) do
			out[#out + 1] = entry
		end
	end
	return out
end

-- Build an application list. An `exact` entry matches one bundle identifier. A
-- `families` entry matches the identifier and its child identifiers, so
-- "com.microsoft.rdc" also matches "com.microsoft.rdc.macos".
local function appList(exact, families)
	return { exact = exact, families = families or {} }
end

-- Terminal emulators. Ctrl is the primary modifier in a terminal.
local TERMINALS = {
	"org.macports.X11",
	"com.apple.Terminal",
	"com.googlecode.iterm2",
	"co.zeit.hyper",
	"co.zeit.hyperterm",
	"org.alacritty",
	"net.kovidgoyal.kitty",
	"com.github.wez.wezterm",
	"com.mitchellh.ghostty",
	"dev.warp.Warp-Stable",
}

-- Remote desktop clients and virtual machines. These send the keystroke to a
-- guest operating system, which expects the unchanged Ctrl chord.
local REMOTE_DESKTOPS = {
	"net.sf.cord",
	"com.thinomenon.RemoteDesktopConnection",
	"com.itap-mobile.qmote",
	"com.nulana.remotixmac",
	"com.teamviewer.TeamViewer",
	"com.vmware.horizon",
	"com.vmware.fusion",
	"com.vmware.view",
	"com.2X.Client.Mac",
	"com.citrix.XenAppViewer",
	"org.virtualbox.app.VirtualBoxVM",
	"tv.parsec.www",
}

-- Each of these identifiers has channel or session variants.
local REMOTE_DESKTOP_FAMILIES = {
	"com.microsoft.rdc",
	"com.p5sys.jump.mac.viewer",
	"com.parallels.desktop",
	"com.parallels.vm",
	"com.parallels.winapp",
	"com.vmware.proxyApp",
}

-- Applications that must get Ctrl unchanged. One list serves every rule,
-- because two lists let their contents drift apart.
local RAW_CTRL_APPS = appList(concat(TERMINALS, REMOTE_DESKTOPS), REMOTE_DESKTOP_FAMILIES)

local FIREFOX_IDS = {
	"org.mozilla.firefox",
	"org.mozilla.firefoxdeveloperedition",
	"org.mozilla.nightly",
}

local FIREFOX = appList(FIREFOX_IDS)

local BROWSERS = appList(
	concat(FIREFOX_IDS, {
		"com.google.Chrome",
		"com.brave.Browser",
		"com.apple.Safari",
	}),
	-- Matches com.microsoft.Edge and its channel variants, such as .Dev.
	{ "com.microsoft.Edge" }
)

-- True if bundleID is an exact entry of the list, or a member of one of its
-- families.
local function isInList(bundleID, list)
	for _, id in ipairs(list.exact) do
		if bundleID == id then
			return true
		end
	end
	for _, id in ipairs(list.families) do
		if bundleID == id or bundleID:sub(1, #id + 1) == id .. "." then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Frontmost application
--------------------------------------------------------------------------------

-- The event tap runs for every keystroke. An accessibility query in that path
-- can make the callback too slow, and macOS then turns the tap off. Hold the
-- bundle identifier in a variable and refresh it from a watcher instead.
local frontBundleID = ""

local function refreshFrontApp()
	local app = hs.application.frontmostApplication()
	frontBundleID = app and app:bundleID() or ""
end

--------------------------------------------------------------------------------
-- Key codes
--------------------------------------------------------------------------------

-- Ctrl+<key> becomes Cmd+<key>: copy, paste, cut, undo, select all, save, new,
-- find, find again, close.
local STANDARD_LETTERS = { "c", "v", "x", "z", "a", "s", "n", "f", "g", "w" }

-- Ctrl+<key> becomes Cmd+<key>: new tab, bold, italic.
local FORMATTING_LETTERS = { "t", "b", "i" }

-- Letters that a rule refers to directly.
local NAMED_LETTERS = { "d", "i", "r", "y" }

local STANDARD_KEYS = {}
local FORMATTING_KEYS = {}
local KEY = {}

-- A layout does not always have every Latin letter. A letter with no key code
-- gets no rule, which leaves the key as it is.
local function addKeyCodes(target, letters)
	for _, letter in ipairs(letters) do
		local keyCode = hs.keycodes.map[letter]
		if keyCode then
			target[keyCode] = true
		end
	end
end

-- hs.keycodes.map changes with the keyboard layout. Build the lookup tables
-- again each time the input source changes.
local function buildKeyTables()
	STANDARD_KEYS = {}
	FORMATTING_KEYS = {}
	addKeyCodes(STANDARD_KEYS, STANDARD_LETTERS)
	addKeyCodes(FORMATTING_KEYS, FORMATTING_LETTERS)
	for _, letter in ipairs(NAMED_LETTERS) do
		KEY[letter] = hs.keycodes.map[letter]
	end
end

--------------------------------------------------------------------------------
-- Rules
--------------------------------------------------------------------------------

-- True when Ctrl is held on its own. AeroSpace owns every ctrl-cmd-alt chord,
-- so a rule must not touch an event that also carries Cmd or Alt.
local function isPlainCtrl(flags)
	return flags.ctrl and not flags.cmd and not flags.alt and not flags.fn
end

-- Decide what to do with a key event. The result is one of:
--   nil       leave the event unchanged
--   "swap"    exchange Ctrl for Cmd on the same key
--   a table   consume the event and send { mods, key } in its place
local function resolve(keyCode, flags)
	-- Opt+D becomes Cmd+L in a browser, to put the caret in the address bar.
	-- Outside a browser the event stays as it is, so Opt+D still types "∂".
	if keyCode == KEY.d and flags.alt and not flags.ctrl and not flags.cmd and not flags.shift then
		if isInList(frontBundleID, BROWSERS) then
			return { mods = { "cmd" }, key = "l" }
		end
		return nil
	end

	if not isPlainCtrl(flags) then
		return nil
	end

	if isInList(frontBundleID, RAW_CTRL_APPS) then
		return nil
	end

	-- Ctrl+Shift+I becomes Cmd+Opt+I in Firefox, to open the developer console.
	-- Keep this rule in front of the FORMATTING_KEYS rule, which also claims
	-- "i" and would otherwise make this chord Cmd+Shift+I.
	if keyCode == KEY.i and flags.shift and isInList(frontBundleID, FIREFOX) then
		return { mods = { "cmd", "alt" }, key = "i" }
	end

	-- Ctrl+Y becomes Cmd+Shift+Z, the macOS redo chord.
	if keyCode == KEY.y and not flags.shift then
		return { mods = { "cmd", "shift" }, key = "z" }
	end

	if STANDARD_KEYS[keyCode] or FORMATTING_KEYS[keyCode] then
		return "swap"
	end

	-- Ctrl+R becomes Cmd+R in a browser, to load the page again.
	if keyCode == KEY.r and isInList(frontBundleID, BROWSERS) then
		return "swap"
	end

	return nil
end

--------------------------------------------------------------------------------
-- Event taps
--------------------------------------------------------------------------------

local EVENT_TYPES = hs.eventtap.event.types

-- Key codes whose key-down was consumed. The matching key-up must go away too,
-- or the application gets a release with no press in front of it.
local consumedKeys = {}

-- Send a chord after the tap callback ends. A keystroke sent from inside the
-- callback holds the event stream open while it is delivered.
local function sendChord(mods, key)
	hs.timer.doAfter(0, function()
		hs.eventtap.keyStroke(mods, key)
	end)
end

local function swapCtrlForCmd(event, flags)
	flags.ctrl = false
	flags.cmd = true
	event:setFlags(flags)
end

local function handleKeyEvent(event)
	if not M.enabled then
		return false
	end

	local keyCode = event:getKeyCode()
	local flags = event:getFlags()

	if event:getType() == EVENT_TYPES.keyUp then
		if consumedKeys[keyCode] then
			consumedKeys[keyCode] = nil
			return true
		end
		-- Mirror a swap on release, so the key-down and the key-up agree about
		-- which modifier is held.
		if resolve(keyCode, flags) == "swap" then
			swapCtrlForCmd(event, flags)
		end
		return false
	end

	local action = resolve(keyCode, flags)

	if action == nil then
		return false
	end

	if action == "swap" then
		swapCtrlForCmd(event, flags)
		return false
	end

	consumedKeys[keyCode] = true
	sendChord(action.mods, action.key)
	return true
end

M.keyEventtap = hs.eventtap.new({ EVENT_TYPES.keyDown, EVENT_TYPES.keyUp }, function(event)
	local ok, result = pcall(handleKeyEvent, event)
	if not ok then
		log.ef("key event tap error: %s", tostring(result))
		return false
	end
	return result
end)

-- Ctrl+Click opens a link in a new tab on Windows, and Cmd+Click does this on
-- macOS. Everywhere else Ctrl+Click is the secondary click gesture, so this
-- rule applies only in a browser.
local function handleMouseEvent(event)
	if not M.enabled then
		return
	end

	local flags = event:getFlags()
	if flags.ctrl and not flags.cmd and isInList(frontBundleID, BROWSERS) then
		swapCtrlForCmd(event, flags)
	end
end

M.mouseEventtap = hs.eventtap.new({
	EVENT_TYPES.leftMouseDown,
	EVENT_TYPES.leftMouseUp,
	EVENT_TYPES.leftMouseDragged,
}, function(event)
	local ok, err = pcall(handleMouseEvent, event)
	if not ok then
		log.ef("mouse event tap error: %s", tostring(err))
	end
	return false
end)

--------------------------------------------------------------------------------
-- Blocked shortcuts
--------------------------------------------------------------------------------

-- Hide application, hide others, and minimise all take windows out of the
-- AeroSpace layout, with no easy way to get them back.
M.blockedHotkeys = {
	hs.hotkey.bind({ "cmd" }, "h", function() end),
	hs.hotkey.bind({ "cmd", "alt" }, "h", function() end),
	hs.hotkey.bind({ "cmd", "alt" }, "m", function() end),
}

--------------------------------------------------------------------------------
-- Control
--------------------------------------------------------------------------------

function M.start()
	M.enabled = true
	M.keyEventtap:start()
	M.mouseEventtap:start()
	for _, hotkey in ipairs(M.blockedHotkeys) do
		hotkey:enable()
	end
end

function M.stop()
	M.enabled = false
	M.keyEventtap:stop()
	M.mouseEventtap:stop()
	for _, hotkey in ipairs(M.blockedHotkeys) do
		hotkey:disable()
	end
	consumedKeys = {}
end

function M.toggle()
	if M.enabled then
		M.stop()
	else
		M.start()
	end
	hs.alert.show("keymaps " .. (M.enabled and "on" or "off"))
end

-- Kill switch, for when a remap gets in the way. AeroSpace does not bind
-- Escape, so this chord is free.
M.toggleHotkey = hs.hotkey.bind({ "ctrl", "cmd", "alt" }, "escape", M.toggle)

--------------------------------------------------------------------------------
-- Keep the taps alive
--------------------------------------------------------------------------------

-- macOS can turn an event tap off with no warning, for example after sleep.
-- Look every 5 seconds and start the tap again. The same timer refreshes the
-- frontmost application, which puts a limit on how stale that value can get if
-- the watcher misses an event.
M.watchdogTimer = hs.timer.new(5, function()
	local ok, err = pcall(function()
		refreshFrontApp()

		if not M.enabled then
			return
		end
		if not M.keyEventtap:isEnabled() then
			log.wf("watchdog: the key event tap was off, starting it again")
			M.keyEventtap:start()
		end
		if not M.mouseEventtap:isEnabled() then
			log.wf("watchdog: the mouse event tap was off, starting it again")
			M.mouseEventtap:start()
		end
	end)
	if not ok then
		log.ef("watchdog timer error: %s", tostring(err))
	end
end)

M.appWatcher = hs.application.watcher.new(function(_, eventType, app)
	if eventType == hs.application.watcher.activated then
		frontBundleID = app and app:bundleID() or ""
	end
end)

M.caffeinateWatcher = hs.caffeinate.watcher.new(function(event)
	local ok, err = pcall(function()
		if event == hs.caffeinate.watcher.systemDidWake or event == hs.caffeinate.watcher.screensDidWake then
			log.f("caffeinate: wake event %d, starting the taps again", event)
			refreshFrontApp()
			if M.enabled then
				M.keyEventtap:start()
				M.mouseEventtap:start()
			end
		end
	end)
	if not ok then
		log.ef("caffeinate watcher error: %s", tostring(err))
	end
end)

--------------------------------------------------------------------------------
-- Start
--------------------------------------------------------------------------------

-- An event tap cannot read the keyboard without this permission, and it needs a
-- relaunch after the permission is given.
if not hs.accessibilityState() then
	log.e("Accessibility permission is off. Give Hammerspoon this permission in "
		.. "System Settings, then start it again.")
	hs.alert.show("keymaps: Hammerspoon needs Accessibility permission")
end

buildKeyTables()
hs.keycodes.inputSourceChanged(buildKeyTables)

refreshFrontApp()

M.appWatcher:start()
M.watchdogTimer:start()
M.caffeinateWatcher:start()
M.start()

log.i("keymaps loaded")

return M
