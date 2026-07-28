-- vtsls: TS/JS language server (Prime stack). Default config, no custom settings.
vim.lsp.config.vtsls = {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
}

vim.lsp.enable("vtsls")
