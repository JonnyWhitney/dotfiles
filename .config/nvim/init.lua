vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_liststyle = 3

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.linebreak = false
vim.o.breakindent = true
vim.o.wrap = true
vim.o.showbreak = "       󱞩"
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

vim.opt_global.listchars = { tab = "» ", space = "·", nbsp = "␣" }

vim.o.undofile = true
vim.o.swapfile = false
vim.o.autoread = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true

vim.o.signcolumn = "yes"

vim.o.hlsearch = true
vim.keymap.set("n", "<Esc>", "<esc>:nohlsearch<CR>", { silent = true })

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.completeopt = { "menuone", "noselect" }

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {},
})

-- [[ Keymaps ]]
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.keymap.set("n", "<leader>w", ":w<cr>", { noremap = true, desc = "write buffer" })
vim.keymap.set("n", "<leader>q", ":q<cr>", { noremap = true, desc = "quit" })
vim.keymap.set("n", "<leader>!", ":q!<cr>", { noremap = true, desc = "nvim force quite" })

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Open file at the last position it was edited earlier",
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

-- go nice error
vim.keymap.set("n", "<leader>Ge", "oif err != nil {}<esc>", { desc = "go insert err check" })
vim.keymap.set(
	"n",
	"<leader>Gw",
	'wbi(<esc>ea)<esc>Bifmt.Errorf<esc>lli"%w", <esc>Ff;<esc>f%',
	{ desc = "go wrap err" }
)

vim.filetype.add({
	extension = {
		service = "systemd",
		mount = "systemd",
		device = "systemd",
		nspawn = "systemd",
		target = "systemd",
		timer = "systemd",
	},
})
