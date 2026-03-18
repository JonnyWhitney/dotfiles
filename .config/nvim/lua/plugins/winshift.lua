---@type LazyPluginSpec
return {
	"sindrets/winshift.nvim",
	keys = {
		{ "<C-w>n", ":WinShift<cr>", noremap = true, silent = true, desc = "toggle WinShift mode" },
	},
	opts = {},
}
