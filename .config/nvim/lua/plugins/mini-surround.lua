return {
	"nvim-mini/mini.surround",
	event = "VeryLazy",
	version = false,
	opts = {
		mappings = {
			add = "<leader>ys",
			delete = "<leader>yd",
			replace = "<leader>yc",
			find = "",
			find_left = "",
			highlight = "",
			update_n_lines = "",
			suffix_last = "",
			suffix_next = "",
		},
	},
	keys = {
		{ "<leader>ys" },
		{ "<leader>yd" },
		{ "<leader>yc" },
	},
}
