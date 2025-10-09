vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
	end,
})
