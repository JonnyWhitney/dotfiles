---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local langs = {
			"bash",
			"caddy",
			"comment",
			"c_sharp",
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
			"jsx",
			"kdl",
			"liquid",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"make",
			"powershell",
			"proto",
			"query",
			"qmljs",
			"razor",
			"regex",
			"rust",
			"scheme",
			"sql",
			"styled",
			"templ",
			"toml",
			"tsx",
			"typescript",
			"vue",
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
