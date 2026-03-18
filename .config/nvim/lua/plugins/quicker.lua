---@type LazyPluginSpec
return {
	"stevearc/quicker.nvim",
	ft = "qf",
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {},
	keys = {
		{
			"<leader>lt",
			function()
				require("quicker").toggle({ focus = true })
			end,
			desc = "Toggle quickfix list",
		},
		{
			"<leader>lr",
			function()
				require("quicker").refresh()
			end,
			desc = "Refresh quickfix list",
		},
	},
}
