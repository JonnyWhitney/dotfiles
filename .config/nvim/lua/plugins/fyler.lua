---@type LazyPluginSpec
return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	opts = {
		views = {
			finder = {
				win = {
					kind = "split_left_most",
					kinds = {
						split_left_most = {
							width = "40",
						},
					},
				},
			},
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
