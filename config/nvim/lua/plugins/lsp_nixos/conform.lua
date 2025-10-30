return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			["_"] = { "trim_whitespace" },
			["*"] = { "codespell" },
			lua = { "stylua" },
			python = { "isort", "black", stop_after_first = true },
			bash = { "shfmt" },
			ruby = { "rubocop" },
			-- nix = { "nixfmt" },
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
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
