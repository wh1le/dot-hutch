vim.lsp.config.nix = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix" },
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixfmt" },
			},
			nix = {
				flake = {
					autoArchive = true,
				},
			},
		},
	},
}

vim.lsp.enable("nix")
