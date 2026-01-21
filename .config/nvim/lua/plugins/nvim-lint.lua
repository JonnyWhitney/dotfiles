return {
	"mfussenegger/nvim-lint",
	-- dir = "~/proj/lints/nvim-lint/",
	ft = { "go", "lua", "javascript", "typescript", "typescriptreact", "sh", "bash", "css" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			go = { "golangcilint" },

			lua = { "luacheck" },

			bash = { "shellcheck" },
			sh = { "shellcheck" },

			python = { "ruff" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
