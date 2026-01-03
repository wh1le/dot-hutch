vim.lsp.config.json = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
}

vim.lsp.enable("json")
