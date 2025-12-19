return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			nixpkgs_fmt = {
				command = "nixpkgs-fmt",
			},
		},
		formatters_by_ft = {
			["_"] = { "trim_whitespace" },
			["*"] = { "codespell" },

			bash = { "shfmt" },
			zsh = { "shfmt" },
			sh = { "shfmt" },
			nix = { "nixpkgs_fmt" },

			ruby = { "rubocop" },
			python = { "isort", "black", stop_after_first = true },
			lua = { "stylua" },

			javascript = { "prettierd", stop_after_first = true },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },

			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			toml = { "taplo" },
			rust = { "rustfmt" },
			ron = { "topiary" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 2000,
		},
	},
}
