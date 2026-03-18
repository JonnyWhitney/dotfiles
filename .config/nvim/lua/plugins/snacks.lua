---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.picker.Config
	opts = {
		quickfile = { enabled = true },
		words = { enabled = true },
		---@type snacks.picker.Config
		picker = {
			previewers = {
				diff = {
					cmd = { "delta" },
					builtin = false,
				},
			},
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
			actions = {
				-- Map a key to load all selected files as background buffers
				load_as_buffers = function(picker)
					local items = picker:selected({ fallback = true })
					picker:close()
					for _, item in ipairs(items) do
						if item.file then
							vim.cmd.badd(item.file)
						end
					end
				end,
			},
			win = {
				input = {
					keys = {
						["<C-o>"] = {
							"load_as_buffers",
							mode = { "i", "n" },
							desc = "Open files as background buffers",
						},
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
				Snacks.picker.files({ cmd = "fd" })
			end,
			desc = "Find Files",
		},
		{
			"<leader>fF",
			function()
				Snacks.picker.files({
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
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>fG",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>fe",
			function()
				Snacks.picker.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		-- search neovim
		{
			'<leader>f"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>fm",
			function()
				Snacks.picker.marks({ global = false })
			end,
			desc = "Local Marks",
		},
		{
			"<leader>fM",
			function()
				Snacks.picker.marks({ ["local"] = false })
			end,
			desc = "Global Marks",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.pickers()
			end,
			desc = "Pickers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		-- git
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"grr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gri",
			function()
				Snacks.picker.lsp_implementations()
			end,
			nowait = true,
			desc = "Implementations",
		},
		{
			"KT",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"Ks",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"KD",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
	},
}
