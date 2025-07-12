return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim",
	},

	config = function()
		require("mason-null-ls").setup({
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
				-- "codespell",
			},
			automatic_installation = true,
		})

		-- register the sources with none-ls
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatOnSave", {})

		null_ls.setup({
			-- diagnostics_format = "#{m}",
			sources = {
				-- 🔧 formatters
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.formatting.standardrb,

				-- null_ls.builtins.code_actions.eslint_d,
				-- null_ls.builtins.code_actions.ruff,

				-- null_ls.builtins.diagnostics.codespell,

				-- null_ls.builtins.formatting.trim_newlines,
				-- null_ls.builtins.formatting.trim_whitespace,
			},

			on_init = function(client)
				client.offset_encoding = "utf-8"
			end,

			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						desc = "💅 auto-format via null-ls before write",
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								async = false, -- blocking keeps file on disk always pretty
								timeout_ms = 2000,
								filter = function(c) -- only pick null-ls (don’t fight other LSPs)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})
	end,
}
