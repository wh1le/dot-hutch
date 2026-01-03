vim.lsp.config.rust = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	rootPatterns = { "Cargo.toml" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
}
vim.lsp.enable("rust")
