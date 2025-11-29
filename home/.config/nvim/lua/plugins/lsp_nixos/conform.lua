return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			["_"] = { "trim_whitespace" },
			["*"] = { "codespell" },

			bash = { "shfmt" },
			zsh = { "shfmt" },
			sh = { "shfmt" },

			ruby = { "rubocop" },
			python = { "isort", "black", stop_after_first = true },
			lua = { "stylua" },

			javascript = { "prettierd", stop_after_first = true },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },

			nix = { "nixfmt" },

			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			toml = { "taplo" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
