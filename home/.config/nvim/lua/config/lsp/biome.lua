vim.lsp.config.biome = {
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"json",
		"jsonc",
		"graphql",
		"css",
	},
	root_markers = { "biome.json", "biome.jsonc" },
	single_file_support = false,
}

vim.lsp.enable("biome")
