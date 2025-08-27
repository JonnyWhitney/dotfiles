vim.bo.commentstring = "// %s"

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "templ" },
	callback = function()
		vim.treesitter.start()
	end,
})
