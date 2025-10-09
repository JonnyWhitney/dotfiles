return {
	"nvim-mini/mini.statusline",
	event = "VeryLazy",
	version = false,
	opts = {
		content = {
			active = function()
				local MiniStatusline = require("mini.statusline")
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 20 })
				local git = MiniStatusline.section_git({ trunc_width = 20 })
				local diff = MiniStatusline.section_diff({ trunc_width = 20 })
				local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 20 })
				local lsp = MiniStatusline.section_lsp({ trunc_width = 20 })
				local filename = MiniStatusline.section_filename({ trunc_width = 170 })
				local location = MiniStatusline.section_location({ trunc_width = 20 })
				local search = MiniStatusline.section_searchcount({ trunc_width = 20 })

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
					"%<", -- Mark general truncate point
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=", -- End left alignment
					{ hl = "MiniStatuslineFileinfo", strings = { search, location } },
				})
			end,
			inactive = function()
				local MiniStatusline = require("mini.statusline")
				local filename = MiniStatusline.section_filename({ trunc_width = 2000 })

				return MiniStatusline.combine_groups({
					"%<", -- Mark general truncate point
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=", -- End left alignment
				})
			end,
		},
	},
}
