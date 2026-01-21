return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			style = "night",
			on_highlights = function(highlights, colors)
				highlights.Folded = {
					bg = "#25283A",
					fg = "#7aa2f7",
				}
			end,
		})
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
