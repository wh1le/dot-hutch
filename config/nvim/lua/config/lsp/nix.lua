vim.lsp.config.nix = {
	cmd = { "nil" },
	filetypes = { "nix" },
	rootPatterns = { "flake.nix" },
}

vim.lsp.enable("nix")
