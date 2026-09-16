return {
	-- "JonnyWhitney/pim",
	dir = "~/proj/PiExtentions/pim/",
	keys = {
		{ "<leader>psm", "<cmd>PiModel<cr>", desc = "Pi: Select model" },
		{ "<leader>pst", "<cmd>PiThinking<cr>", desc = "Pi: Set thinking level" },
		{ "<leader>pt", "<cmd>PiTree<cr>", desc = "Pi: View tree" },
		{ "<leader>pr", "<cmd>PiResume<cr>", desc = "Pi: Resume session" },
	},
	cmd = {
		"PiStart",
		"PiToggle",
		"PiSend",
		"PiAbort",
		"PiResume",
		"PiTree",
		"PiTrust",
		"PiNewSession",
		"PiFork",
		"PiClone",
		"PiModel",
		"PiThinking",
		"PiRestart",
		"PiStop",
		"PiLog",
	},
	config = function()
		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function(args)
				if vim.b[args.buf].pim_role == "input" then
					vim.opt_local.spell = true
				end
			end,
		})

		require("pim").setup({
			input = { min_height = 10, max_height = 30 },
			completion = { respect_gitignore = false },
		})
	end,
}
