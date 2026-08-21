return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				elixir = { "mix" },
				go = { "gofmt" },

				bash = { "shfmt" },
				sh = { "shfmt" },
				nix = { "nixfmt" },

				ruby = { "rubocop" },
				python = { "isort", "black", stop_after_first = true },
				lua = { "stylua" },

				javascript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },
				graphql = { "biome" },

				json = { "biome", "prettierd", stop_after_first = true },
				yaml = { "prettierd" },
				markdown = { "mdformat" },
				css = { "biome", "prettierd", stop_after_first = true },
				scss = { "prettierd" },
				html = { "prettierd" },
				toml = { "taplo" },
				rust = { "rustfmt" },
				ron = { "topiary" },
			},
			formatters = {
				biome = {
					condition = function(self, ctx)
						return vim.fs.find(
							{ "biome.json", "biome.jsonc" },
							{ path = ctx.filename, upward = true }
						)[1]
					end,
				},
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				rubocop = {
					{ "--server", "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
				},
			},
			-- format_after_save = {
			--   lsp_format = "fallback",
			-- },
		})

		-- vim.keymap.set("n", "<leader>f", function()
		-- 	require("conform").format({ bufnr = 0 })
		-- end)

		vim.keymap.set("n", "<leader>cf", function()
			require("conform").format({ bufnr = 0, timeout_ms = 10000 })
		end)
	end,
}
