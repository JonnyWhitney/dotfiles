-- Require the sketchybar module
--- @type Sketchybar
Sbar = require("sketchybar")

-- Bundle the entire initial configuration into a single message to sketchybar
Sbar.begin_config()

-- Hot Reloading
Sbar.hotload(true)

-- Source Items
require("settings")
require("defaults")
require("bar")
require("items")

Sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
Sbar.event_loop()
