return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		quickfile = { enabled = true },
		words = { enabled = true },
		---@type snacks.picker.Config
		picker = {
			-- previewers = {
			-- 	diff = {
			-- 		cmd = { "delta" },
			-- 		builtin = false,
			-- 	},
			-- },
			layouts = {
				default = {
					layout = {
						box = "horizontal",
						width = 0.8,
						min_width = 120,
						height = 0.8,
						{
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
						},
						{ win = "preview", title = "{preview}", border = "rounded", width = 0.7 },
					},
				},
			},
		},
	},
	keys = {
		-- PICKER
		-- find files/lines
		{
			"<leader>ff",
			function()
				require("snacks").picker.files({ cmd = "fd" })
			end,
			desc = "Find Files",
		},
		{
			"<leader>fF",
			function()
				---@diagnostic disable-next-line: missing-fields
				require("snacks").picker.files({
					cmd = "fd",
					hidden = true,
					ignored = true,
				})
			end,
			desc = "Find All Files",
		},
		{
			"<leader>fg",
			function()
				require("snacks").picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>fG",
			function()
				require("snacks").picker.grep()
			end,
			desc = "Grep",
		},
		-- search neovim
		{
			'<leader>f"',
			function()
				require("snacks").picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>fm",
			function()
				require("snacks").picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>fc",
			function()
				require("snacks").picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>fC",
			function()
				require("snacks").picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>fk",
			function()
				require("snacks").picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>fp",
			function()
				require("snacks").picker.pickers()
			end,
			desc = "Pickers",
		},
		{
			"<leader>fh",
			function()
				require("snacks").picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>fM",
			function()
				require("snacks").picker.man()
			end,
			desc = "Man Pages",
		},
		-- git
		{
			"<leader>gl",
			function()
				require("snacks").picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gs",
			function()
				require("snacks").picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gd",
			function()
				require("snacks").picker.git_diff()
			end,
			desc = "Git Diff",
		},
		{
			"<leader>fe",
			function()
				require("snacks").picker.explorer()
			end,
			desc = "Git Diff",
		},
		-- {
		-- 	"<leader>gD",
		-- 	function()
		-- 		require("snacks").picker.git_diff(
		-- 			--- @type snacks.picker.git.Config
		-- 			{
		-- 				args = { "--staged" },
		-- 			}
		-- 		)
		-- 	end,
		-- 	desc = "Git Diff",
		-- },
		-- LSP
		{
			"gd",
			function()
				require("snacks").picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"grr",
			function()
				require("snacks").picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gri",
			function()
				require("snacks").picker.lsp_implementations()
			end,
			nowait = true,
			desc = "Implementations",
		},
		{
			"KT",
			function()
				require("snacks").picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"Ks",
			function()
				require("snacks").picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"KD",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
	},
}
