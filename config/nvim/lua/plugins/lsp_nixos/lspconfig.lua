return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp",
	},
	keys = {
		{
			"K",
			function()
				vim.lsp.buf.hover()
			end,
			desc = "Built-in: vim.lsp.buf.hover()",
		},
		{
			"gd",
			function()
				vim.lsp.buf.definition()
			end,
			desc = "Go to def",
		},
		{
			"gr",
			function()
				vim.lsp.buf.references()
			end,
			desc = "Ref",
		},
		{
			"<leader>rn",
			function()
				vim.lsp.buf.rename()
			end,
			desc = "Rename",
		},
		{
			"<leader>ca",
			function()
				vim.lsp.buf.code_action()
			end,
			desc = "Code action",
		},
		{
			"<leader>de",
			function()
				vim.diagnostic.open_float(
					nil,
					{ focus = false, border = "rounded", source = "always", scope = "cursor" }
				)
			end,
			desc = "Explain diagnostic under cursor",
		},
	},
	init = function()
		-- local defaults = {}
		local lspconfig = require("lspconfig")

		local function apply_diag_signs()
			local signs = { Error = "󰢱", Warn = "", Info = "»", Hint = "" }

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			vim.diagnostic.config({
				underline = false,
				-- underline = {
				-- 	severity = { min = vim.diagnostic.severity.WARN },
				-- },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN] = signs.Warn,
						[vim.diagnostic.severity.INFO] = signs.Info,
						[vim.diagnostic.severity.HINT] = signs.Hint,
					},
					numhl = false,
					severity = { min = vim.diagnostic.severity.WARN },
				},
				severity = { min = vim.diagnostic.severity.WARN },

				virtual_text = {
					severity = { min = vim.diagnostic.severity.WARN },
					current_line = true,
				},
				float = {
					border = "rounded",
					source = "always",
					severity = { min = vim.diagnostic.severity.WARN },
				},
				severity_sort = true,
			})
		end

		-- capabilities --

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, {
			offsetEncoding = { "utf-16" },
			general = {
				positionEncodings = { "utf-16" },
			},
		})

		capabilities.textDocument.signatureHelp = {
			dynamicRegistration = false,
			signatureInformation = {
				documentationFormat = { "markdown", "plaintext" },
				parameterInformation = { labelOffsetSupport = true },
			},
		}

		-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
		lspconfig.jsonls.setup({ capabilities = capabilities })
		lspconfig.yamlls.setup({ capabilities = capabilities })
		lspconfig.ts_ls.setup({ capabilities = capabilities })
		lspconfig.eslint.setup({ capabilities = capabilities })
		lspconfig.pyright.setup({ capabilities = capabilities })
		lspconfig.ruff.setup({ capabilities = capabilities })
		lspconfig.taplo.setup({ capabilities = capabilities })
		lspconfig.marksman.setup({ capabilities = capabilities })
		lspconfig.nil_ls.setup({ capabilities = capabilities })
		lspconfig.typos_lsp.setup({ capabilities = capabilities })
		-- lspconfig.ruby_lsp.setup({ capabilities = capabilities, cmd = { "ruby-lsp" } })
		lspconfig.ruby_lsp.setup({ capabilities = capabilities })
		lspconfig.rubocop.setup({ capabilities = capabilities })
		lspconfig.bashls.setup({
			settings = {
				["bash-language-server"] = {},
			},
			filetypes = {
				"zsh",
				"bash",
			},
		})
		lspconfig.yamlls.setup({ capabilities = capabilities })

		-- TODO: investigate
		-- vscode-langservers-extracted
		-- typescript-language-server
		-- typescript
		-- vscode-langservers-extracted

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "require" } },
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = { enable = false },
				},
			},
		})
		-- capabilities --

		vim.api.nvim_create_autocmd({ "UIEnter", "LspAttach", "ColorScheme" }, { callback = apply_diag_signs })
		-- vim.lsp.config("*", defaults)
		-- delay update diagnostics
		vim.lsp.handlers["textDocument/publishDiagnostics"] =
			vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false })
	end,
}
