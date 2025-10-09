return {
	"nvim-mini/mini.diff",
	event = "VeryLazy",
	version = false,
	opts = {
		mappings = {
			-- Apply hunks inside a visual/operator region
			apply = "<leader>gha",

			-- Reset hunks inside a visual/operator region
			reset = "<leader>ghr",
		},
	},
	keys = {
		{ "<leader>gha" },
		{ "<leader>ghr" },
		{
			"<leader>go",
			function()
				---@diagnostic disable-next-line: missing-parameter Nil gives current buffer
				require("mini.diff").toggle_overlay()
			end,
			desc = "Toggle Mini Overlay",
		},
	},
}
