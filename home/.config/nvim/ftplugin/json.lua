vim.g.vim_json_syntax_conceal = 0
vim.g.conceallevel = 0

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = ".eslintrc",
	callback = function()
		vim.bo.filetype = "json"
	end,
})

vim.api.nvim_create_augroup("NoConcealJSON", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "NoConcealJSON",
	pattern = "json",
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
