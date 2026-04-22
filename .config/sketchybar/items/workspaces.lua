local colors = require("colors")
local settings = require("settings")

local query_workspaces =
	"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

-- Root is used to handle event subscriptions
local root = Sbar.add("item", { drawing = false })
local workspaces = {}

local function withWindows(f)
	local open_windows = {}
	-- Include the window ID in the query so we can track unique windows
	local get_windows = "aerospace list-windows --monitor all --format '%{workspace}%{app-name}%{window-id}' --json"
	local query_visible_workspaces =
		"aerospace list-workspaces --visible --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"
	local get_focus_workspaces = "aerospace list-workspaces --focused"
	Sbar.exec(get_windows, function(workspace_and_windows)
		---@cast workspace_and_windows table   -- --json always returns a decoded table
		-- Use a set to track unique window IDs
		local processed_windows = {}

		for _, entry in ipairs(workspace_and_windows) do
			local workspace_index = entry.workspace
			local app = entry["app-name"]
			local window_id = entry["window-id"]

			-- Only process each window ID once
			if not processed_windows[window_id] then
				processed_windows[window_id] = true

				if open_windows[workspace_index] == nil then
					open_windows[workspace_index] = {}
				end

				-- Check if this app is already in the list for this workspace
				local app_exists = false
				for _, existing_app in ipairs(open_windows[workspace_index]) do
					if existing_app == app then
						app_exists = true
						break
					end
				end

				-- Only add the app if it's not already in the list
				if not app_exists then
					table.insert(open_windows[workspace_index], app)
				end
			end
		end

		Sbar.exec(get_focus_workspaces, function(focused_workspaces)
			Sbar.exec(query_visible_workspaces, function(visible_workspaces)
				local args = {
					open_windows = open_windows,
					focused_workspaces = focused_workspaces,
					visible_workspaces = visible_workspaces,
				}
				f(args)
			end)
		end)
	end)
end

local function updateWindow(workspace_index, args)
	local open_windows = args.open_windows[workspace_index]
	local focused_workspaces = args.focused_workspaces
	local visible_workspaces = args.visible_workspaces

	if open_windows == nil then
		open_windows = {}
	end

	local no_app = #open_windows == 0

	Sbar.animate("tanh", 10, function()
		for _, visible_workspace in ipairs(visible_workspaces) do
			if no_app and workspace_index == visible_workspace["workspace"] then
				local monitor_id = visible_workspace["monitor-appkit-nsscreen-screens-id"]
				workspaces[workspace_index]:set({
					drawing = true,
					display = monitor_id,
				})
				return
			end
		end
		if no_app and workspace_index ~= focused_workspaces then
			workspaces[workspace_index]:set({
				drawing = false,
			})
			return
		end
		if no_app and workspace_index == focused_workspaces then
			workspaces[workspace_index]:set({
				drawing = true,
			})
		end

		workspaces[workspace_index]:set({
			drawing = true,
		})
	end)
end

local function updateWindows()
	withWindows(function(args)
		for workspace_index, _ in pairs(workspaces) do
			updateWindow(workspace_index, args)
		end
	end)
end

local function updateWorkspaceMonitor()
	local workspace_monitor = {}
	Sbar.exec(query_workspaces, function(workspaces_and_monitors)
		---@cast workspaces_and_monitors table   -- --json always returns a decoded table
		for _, entry in ipairs(workspaces_and_monitors) do
			local space_index = entry.workspace
			local monitor_id = math.floor(entry["monitor-appkit-nsscreen-screens-id"])
			workspace_monitor[space_index] = monitor_id
		end
		for workspace_index, _ in pairs(workspaces) do
			workspaces[workspace_index]:set({
				display = workspace_monitor[workspace_index],
			})
		end
	end)
end

local function addWorkspace(workspace_index, needs_reorder)
	if workspaces[workspace_index] then return end -- already exists, skip

	local item_name = "workspace." .. workspace_index
	local workspace = Sbar.add("item", item_name, {
		background = {
			color = colors.bg,
			drawing = true,
		},
		click_script = "aerospace workspace " .. workspace_index,
		drawing = false, -- Hide all items at first
		icon = {
			color = colors.dim,
			drawing = true,
			font = settings.font,
			highlight_color = 0xffffffff,
			padding_left = 8,
			padding_right = 8,
			string = workspace_index,
		},
		label = { drawing = false },
	})

	workspaces[workspace_index] = workspace

	if needs_reorder then
		-- Find the smallest existing workspace index numerically greater than workspace_index
		local insert_before = "front_app"
		local existing = {}
		for k in pairs(workspaces) do
			if k ~= workspace_index then
				table.insert(existing, k)
			end
		end
		table.sort(existing, function(a, b)
			return tonumber(a) < tonumber(b)
		end)
		for _, k in ipairs(existing) do
			if tonumber(k) > tonumber(workspace_index) then
				insert_before = "workspace." .. k
				break
			end
		end
		Sbar.exec("sketchybar --move " .. item_name .. " before " .. insert_before)
	end

	workspace:subscribe("aerospace_workspace_change", function(env)
		local focused_workspace = env.FOCUSED_WORKSPACE
		local is_focused = focused_workspace == workspace_index

		Sbar.animate("tanh", 10, function()
			workspace:set({
				icon = { highlight = is_focused },
				label = { highlight = is_focused },
				blur_radius = 30,
			})
		end)
	end)
end

local function refreshWorkspaces(callback)
	Sbar.exec(query_workspaces, function(workspaces_and_monitors)
		---@cast workspaces_and_monitors table   -- --json always returns a decoded table
		for _, entry in ipairs(workspaces_and_monitors) do
			local workspace_index = entry.workspace
			if not workspaces[workspace_index] then
				addWorkspace(workspace_index, true)  -- needs_reorder = true
			end
		end
		if callback then callback() end
	end)
end

Sbar.exec(query_workspaces, function(workspaces_and_monitors)
	---@cast workspaces_and_monitors table   -- --json always returns a decoded table
	for _, entry in ipairs(workspaces_and_monitors) do
		addWorkspace(entry.workspace)
	end

	require("items.front_app")

	-- Initial setup
	updateWindows()
	updateWorkspaceMonitor()

	root:subscribe("aerospace_workspace_change", function()
		refreshWorkspaces(function()
			updateWindows()
			updateWorkspaceMonitor()
		end)
	end)

	-- Subscribe to front app changes too
	root:subscribe("front_app_switched", function()
		updateWindows()
	end)

	root:subscribe("display_change", function()
		updateWorkspaceMonitor()
		updateWindows()
	end)

	Sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
		---@cast focused_workspace string   -- plain text, not JSON
		local trimmed = focused_workspace:match("^%s*(.-)%s*$")
		if workspaces[trimmed] then
			workspaces[trimmed]:set({
				icon = { highlight = true },
				label = { highlight = true },
			})
		end
	end)
end)
