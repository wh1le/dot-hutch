return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim", -- ⬅ renames: null-ls → none-ls
	},

	config = function()
		require("mason-null-ls").setup({
			-- everything Mason should auto-download for null-ls
			ensure_installed = {
				-- "black", -- formatter
				-- "isort", -- import-sorter / formatter
				"ruff", -- linter + quick-fixes

				"rubocop",

				"prettierd", -- fast Prettier daemon
				"eslint_d", -- eslint daemon (diagnostics + code-actions)

				"stylua",

				"shfmt", -- formatter
				"shellcheck", -- diagnostics

				"jq",
			},

			-- auto-install anything listed above when you open a file that needs it
			automatic_installation = true,
		})

		-- register the sources with none-ls
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- 🔧 formatters
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.formatting.standardrb,
				null_ls.builtins.formatting.jq,

				null_ls.builtins.code_actions.eslint_d,
				null_ls.builtins.code_actions.ruff,
			},
		})
	end,
}
