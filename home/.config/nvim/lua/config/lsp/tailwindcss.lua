vim.lsp.config.tailwindcss = {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"heex",
	},
}

-- Auto-enable when opening relevant files
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"heex",
	},
	callback = function()
		vim.lsp.enable("tailwindcss")
	end,
})
