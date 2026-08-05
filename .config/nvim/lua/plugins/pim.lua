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
		"PiStop",
		"PiRestart",
		"PiAbort",
		"PiSend",
		"PiResume",
		"PiNewSession",
		"PiModel",
		"PiThinking",
		"PiLog",
	},
	-- setup() is optional; uncomment to customize:
	-- opts = { debug = true },
}
