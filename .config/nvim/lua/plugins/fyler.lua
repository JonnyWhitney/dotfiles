return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "echasnovski/mini.icons" },
	opts = {
		views = {
			explorer = {
				win = {
					kind = "split_left_most",
					kind_presets = {
						split_left_most = {
							width = "40abs",
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
