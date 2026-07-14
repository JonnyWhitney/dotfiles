local lazy_dirs = vim.fn.glob("~/.local/share/nvim/lazy/*", true, true)

---@type LazyPluginSpec
return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	build = function()
		require("blink.cmp").build():pwait()
	end,
	dependencies = {
		{ "saghen/blink.lib" },
		{
			"folke/lazydev.nvim",
			ft = "lua",

			---@class lazydev.Config
			opts = {
				library = lazy_dirs,
				integrations = {
					cmp = false,
					blink = true,
				},
			},
		},
	},
	opts = {
		sources = {
			default = {
				-- Paths
				"lsp",
				"omni",
				"path",
				"buffer",
				"lazydev",
			},
			providers = {
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
			},
			per_filetype = {
				minifiles = { inherit_defaults = false },
			},
		},
		completion = {
			keyword = { range = "full" },
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			menu = {
				max_height = 20,
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description" },
						{ "source_name", "item_client_name", gap = 1 },
					},
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
						},
						item_client_name = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.item.client_name
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},
			trigger = {
				prefetch_on_insert = false,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			ghost_text = { enabled = true },
		},
		signature = { enabled = true },
		cmdline = {
			enabled = true,
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				menu = { auto_show = true },
			},
		},
	},
	opts_extend = { "sources.default" },
}
