-- vim.lsp.config.nix = {
-- 	cmd = { "nil" },
-- 	filetypes = { "nix" },
-- 	rootPatterns = { "flake.nix" },
-- 	settings = {
-- 		testSetting = 42,
-- 	},
-- }

vim.lsp.config.nix = {
	cmd = { "nil" },
	filetypes = { "nix" },
	rootPatterns = { "flake.nix" },
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixpkgs-fmt" },
			},
		},
	},
}
vim.lsp.enable("nix")
