---@type LazyPluginSpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 0,
	},
	keys = {
		{
			"K",
			function()
				require("which-key").show("K")
			end,
			desc = "LSP",
		},
	},
}
