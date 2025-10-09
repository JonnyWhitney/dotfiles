return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		{ "saghen/blink.cmp" },
		{
			"nanotee/sqls.nvim",
			ft = { "sql" },
			keys = {
				{ "<leader>ds", "<cmd>SqlsSwitchConnection<cr>", desc = "Sqls Switch Connection" },
			},
		},
	},
	config = function()
		-- Configure server opts
		local serverOpts = {}
		serverOpts["bashls"] = { filetypes = { "bash", "sh", "zsh" } }
		serverOpts["biome"] = { filetypes = { "javascript", "typescript", "typescriptreact", "css", "html" } }
		serverOpts["cssls"] = { filetypes = { "css" } }
		serverOpts["gopls"] = {
			settings = {
				gopls = {
					gofumpt = true,
					hints = {
						enable = true,
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
						functionParameterNames = true,
					},
				},
			},
		}
		serverOpts["html"] = { filetypes = { "html", "templ" } }
		serverOpts["hyprls"] = {}
		serverOpts["jsonls"] = {}
		serverOpts["lua_ls"] = {}
		serverOpts["marksman"] = {}
		serverOpts["rust_analyzer"] = {}
		serverOpts["sqls"] = {
			on_attach = function(client, bufnr)
				require("sqls").on_attach(client, bufnr)
			end,
		}
		serverOpts["systemd_ls"] = {
			name = "systemd_ls",
			cmd = { "/home/jonny/.cargo/bin/systemd-lsp" },
			root_dir = vim.fn.getcwd(),
		}
		-- serverOpts["tailwindcss"] = {
		-- 	filetypes = { "html", "javascriptreact", "templ", "typescriptreact" },
		-- 	init_options = { userLanguages = { templ = "html" } },
		-- }
		-- -- VUE SPECIFIC
		-- local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
		-- local vue_plugin = {
		-- 	name = "@vue/typescript-plugin",
		-- 	location = "/home/jonny/.bun/bin/vue-language-server",
		-- 	languages = { "vue" },
		-- 	configNamespace = "typescript",
		-- }
		serverOpts["ts_ls"] = {
			-- filetypes = tsserver_filetypes, -- VUE SPECIFIC
			init_options = {
				preferences = {
					importModuleSpecifierPreference = "non-relative",
					importModuleSpecifierEnding = "js",
				},
				-- plugins = { -- VUE SPECIFIC
				-- 	vue_plugin,
				-- },
			},
		}

		-- serverOpts["vue_ls"] = {} -- VUE SPECIFIC

		serverOpts["templ"] = {}
		serverOpts["taplo"] = {}
		serverOpts["qmlls"] = { cmd = { "qmlls6" } }
		serverOpts["yamlls"] = {}

		-- Setup each server
		for server, config in pairs(serverOpts) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		local function map(rhs, lhs, desc)
			vim.keymap.set("n", rhs, lhs, { desc = desc })
		end

		-- Buffer local mappings.
		map("KE", vim.diagnostic.open_float, "Float Error")
		map("KK", vim.lsp.buf.hover, "Hover Docuementation")
		map("grn", vim.lsp.buf.rename, "Rename")
		map("gra", vim.lsp.buf.code_action, "Code Action")
		map("KH", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
		end, "Toggle Inlay Hints")
		-- })
	end,
}
