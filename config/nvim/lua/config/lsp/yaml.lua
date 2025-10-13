vim.lsp.config.yaml = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
}

vim.lsp.enable("yamlls")
