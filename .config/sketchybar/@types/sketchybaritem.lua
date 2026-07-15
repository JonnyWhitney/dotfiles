---@meta

---@class SketchybarItem
---@field name string
local SketchybarItem = {}

--- Sets properties on the item.
---@param props ItemProperties
function SketchybarItem:set(props) end

--- Subscribes the item to one or more events.
---@param event SketchybarEvent | string | (SketchybarEvent | string)[]
---@param callback fun(env: SketchybarEventEnv)
function SketchybarItem:subscribe(event, callback) end

--- Returns a table of the item's current properties.
---@return table
function SketchybarItem:query() end
