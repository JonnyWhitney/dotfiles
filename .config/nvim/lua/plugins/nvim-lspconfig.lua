---@type LazyPluginSpec
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
		-- serverOpts["biome"] = { filetypes = { "javascript", "typescript", "typescriptreact", "css", "html" } }
		serverOpts["buf_ls"] = {}
		serverOpts["cssls"] = { filetypes = { "css" } }
		serverOpts["eslint"] = { filetypes = { "css", "typescript" } }
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
		serverOpts["lua_ls"] = {
			settings = {
				Lua = {
					workspace = {
						library = { vim.env.VIMRUNTIME .. "/lua" },
					},
				},
			},
		}
		serverOpts["marksman"] = {}
		serverOpts["rust_analyzer"] = {}
		serverOpts["shopify_theme_ls"] = {}
		serverOpts["sqls"] = {
			on_attach = function(client, bufnr)
				require("sqls").on_attach(client, bufnr)
			end,
		}
		serverOpts["systemd_lsp"] = {}
		local ts_root_markers = { "package-lock.json", "pnpm-lock.yaml", "yarn.lock", "bun.lock", "bun.lockb", ".git" }
		local function has_tsserver_js(root)
			return vim.uv.fs_stat(vim.fs.joinpath(root, "node_modules/typescript/lib/tsserver.js")) ~= nil
		end
		serverOpts["ts_ls"] = {
			root_dir = function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, ts_root_markers)
				if root and has_tsserver_js(root) then
					on_dir(root)
				end
			end,
		}
		serverOpts["tsgo"] = {
			root_dir = function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, ts_root_markers)
				if root and not has_tsserver_js(root) then
					on_dir(root)
				end
			end,
			cmd = function(dispatchers, config)
				local cmd = "tsgo"
				local root = (config or {}).root_dir
				if root then
					for _, bin in ipairs({ "tsgo", "tsc" }) do
						local local_bin = vim.fs.joinpath(root, "node_modules/.bin", bin)
						if vim.fn.executable(local_bin) == 1 then
							cmd = local_bin
							break
						end
					end
				end
				return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
			end,
		}
		serverOpts["templ"] = {}
		serverOpts["taplo"] = {}
		serverOpts["ty"] = {}
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
