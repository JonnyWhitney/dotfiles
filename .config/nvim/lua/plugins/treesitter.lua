return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local langs = {
			"bash",
			"comment",
			"css",
			-- "csv", Just Use Plugin
			"desktop",
			"diff",
			"dockerfile",
			"git_config",
			"gitcommit",
			"go",
			"gomod",
			"gosum",
			"html",
			"http",
			"hyprlang",
			"javascript",
			"jq",
			"jsdoc",
			"json",
			"json5",
			"jsonc",
			"jsx",
			"kdl",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"make",
			"powershell",
			"proto",
			"query",
			"qmljs",
			"rust",
			"scheme",
			"sql",
			"templ",
			"toml",
			"tsx",
			"typescript",
			"vimdock",
			"yaml",
			"zig",
		}

		require("nvim-treesitter").install(langs)

		for _, parser in pairs(langs) do
			local filetypes = vim.treesitter.language.get_filetypes(parser)
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = filetypes,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end
	end,
}
