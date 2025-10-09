return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	opts = {
		win = {
			kind = "split_left_most",
			kind_presets = {
				split_left_most = {
					width = "40abs",
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
