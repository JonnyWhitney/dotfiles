---@meta

---@class Sketchybar
local Sketchybar = {}

--- Configures global bar appearance and layout.
---@param props BarProperties
function Sketchybar.bar(props) end

--- Sets default properties applied to all subsequently created items.
---@param props DefaultProperties
function Sketchybar.default(props) end

--- Creates a new bar item, bracket, slider, graph, or event and returns a handle.
---@overload fun(type: "item"|"space"|"alias", props: ItemProperties): SketchybarItem
---@overload fun(type: "item"|"space"|"alias", name: string, props: ItemProperties): SketchybarItem
---@overload fun(type: "bracket", name: string, members: string[], props: ItemProperties): SketchybarItem
---@overload fun(type: "slider"|"graph", name: string, width: integer, props: ItemProperties): SketchybarItem
---@overload fun(type: "event", name: string, notification?: string): SketchybarItem
---@param type ItemType
---@return SketchybarItem
function Sketchybar.add(type, ...) end

--- Runs a shell command asynchronously, optionally calling back with stdout and exit code.
---@param command string
---@param callback? fun(result: string | table, exit_code: integer)
function Sketchybar.exec(command, callback) end

--- Fires a custom event, optionally passing an env table to subscribers.
---@param event string
---@param env? table
function Sketchybar.trigger(event, env) end

--- Queries bar-wide or item configuration, returning a decoded table.
---@overload fun(target: "bar"): table
---@overload fun(target: "defaults"): table
---@overload fun(target: "events"): table
---@overload fun(target: "default_menu_items"): table
---@overload fun(target: "displays"): table
---@overload fun(target: string): table
---@param target string
---@return table
function Sketchybar.query(target) end

--- Pushes a data point (0.0–1.0) onto a graph or slider item.
---@param name string
---@param value number
function Sketchybar.push(name, value) end

--- Wraps a function call in an animation with the given easing curve and frame count.
---@param curve AnimationCurve
---@param duration integer
---@param fn fun()
function Sketchybar.animate(curve, duration, fn) end

--- Marks the start of a batched config block (suppresses redraws until end_config).
function Sketchybar.begin_config() end

--- Ends a batched config block and flushes all pending updates.
function Sketchybar.end_config() end

--- Enables or disables automatic config reload on file changes.
---@param enabled boolean
function Sketchybar.hotload(enabled) end

--- Starts the SbarLua event loop (blocking — call at end of sketchybarrc.lua).
function Sketchybar.event_loop() end

--- Overrides the target bar name (default: "sketchybar").
---@param name string
function Sketchybar.set_bar_name(name) end

return Sketchybar
