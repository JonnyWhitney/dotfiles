---@type LazyPluginSpec
return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	opts = {
		kind = "floating",
		ui = {
			hidden_items = {
				switches = {},
			},
			indent_guides = true,
		},
	},
	keys = {
		{
			"<leader>ft",
			"<cmd>Fyler<cr>",
			desc = "Open Mini Files",
		},
	},
}
