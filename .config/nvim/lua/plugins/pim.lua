return {
	"JonnyWhitney/pim",
	keys = {
		{ "<leader>pm", "<cmd>PiModel<cr>", desc = "Pi: Select model" },
		{ "<leader>pt", "<cmd>PiThinking<cr>", desc = "Pi: Set thinking level" },
		{ "<leader>ps", "<cmd>PiStart<cr>", desc = "Pi: Start pi" },
		{ "<leader>pq", "<cmd>PiStop<cr>", desc = "Pi: Stop pi" },
		{ "<leader>pr", "<cmd>PiResume<cr>", desc = "Pi: Resume a pi session" },
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
	end,
}
