return {
	-- 📡  LSP core
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
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
		},

		init = function()
			local defaults = {}
			local lspconfig = require("lspconfig")

			for type, icon in pairs({
				Error = "✘",
				Warn = "➜",
				Hint = "💡",
				Info = "➜",
			}) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- Show line diagnostics automatically in hover window
			vim.o.updatetime = 250
			vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

			-- apply defaults to every server
			vim.lsp.config("*", defaults)

			-- 🔇 kill inline spam everywhere
			-- vim.api.nvim_create_autocmd("CursorHold", {
			-- 	callback = function()
			-- 		vim.diagnostic.open_float(nil, {
			-- 			focusable = false,
			-- 			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			-- 			border = "rounded",
			-- 			source = "always", -- show “prism” in header
			-- 			scope = "cursor", -- just the diagnostic under the caret
			-- 		})
			-- 	end,
			-- })
			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	callback = function()
			-- 		vim.diagnostic.config({ virtual_text = false })
			-- 	end,
			-- })
			-- -- 🛡️ optional: re-disable if some plugin flips it back on
			-- vim.api.nvim_create_autocmd("BufEnter", {
			-- 	callback = function()
			-- 		vim.diagnostic.config({ virtual_text = false })
			-- 	end,
			-- })

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Signatures
			capabilities.textDocument.signatureHelp = {
				dynamicRegistration = false,
				signatureInformation = {
					documentationFormat = { "markdown", "plaintext" },
					parameterInformation = { labelOffsetSupport = true },
				},
			}

			-- triggered with (
			vim.api.nvim_create_autocmd("InsertCharPre", {
				pattern = "*",
				callback = function()
					local char = vim.v.char
					if char == "(" or char == "," then
						vim.defer_fn(function()
							vim.lsp.buf.signature_help()
						end, 0)
					end
				end,
			})

			-- On type formatting
			capabilities.textDocument.documentOnTypeFormatting = {
				firstTriggerCharacter = "\n", -- usually newline or `}`
			}

			lspconfig.ruby_lsp.setup({
				capabilities = capabilities,
			})

			-- per-server override
			-- vim.lsp.config(
			-- 	"lua_ls",
			-- 	vim.tbl_deep_extend("force", defaults, {
			-- 		settings = {
			-- 			Lua = {
			-- 				runtime = { version = "LuaJIT" },
			-- 				diagnostics = { globals = { "vim", "require" } },
			-- 				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			-- 				telemetry = { enable = false },
			-- 			},
			-- 		},
			-- 	})
			-- )

			-- local caps = require("cmp_nvim_lsp").default_capabilities()
			-- caps.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
			--
			-- require("lspconfig.util").default_config =
			-- 	vim.tbl_deep_extend("force", require("lspconfig.util").default_config, { capabilities = caps })
		end,
	},
}
