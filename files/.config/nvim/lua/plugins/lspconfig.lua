return {
	-- 📡  LSP core
	{
		"neovim/nvim-lspconfig",
		-- event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},

		init = function()
			local defaults = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				on_attach = function(_, b)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = b, desc = desc })
					end
					map("K", vim.lsp.buf.hover, "Hover docs")
					map("gd", vim.lsp.buf.definition, "Go to def")
					map("gr", vim.lsp.buf.references, "Refs")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					-- map("[d", vim.diagnostic.goto_prev, "Prev diag")
					-- map("]d", vim.diagnostic.goto_next, "Next diag")
				end,
			}

			for type, icon in pairs({
				Error = "✘",
				Warn = "➜",
				Hint = "💡",
				Info = "➜",
			}) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- vim.diagnostic.config({
			--   virtual_text = false
			-- })

			-- Show line diagnostics automatically in hover window
			vim.o.updatetime = 250
			vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

			-- apply defaults to every server
			vim.lsp.config("*", defaults)

			-- 🔇 kill inline spam everywhere
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always", -- show “prism” in header
						scope = "cursor", -- just the diagnostic under the caret
					})
				end,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function()
					vim.diagnostic.config({ virtual_text = false })
				end,
			})
			-- 🛡️ optional: re-disable if some plugin flips it back on
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					vim.diagnostic.config({ virtual_text = false })
				end,
			})

			-- per-server override
			vim.lsp.config(
				"lua_ls",
				vim.tbl_deep_extend("force", defaults, {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim", "require" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				})
			)

			-- local caps = require("cmp_nvim_lsp").default_capabilities()
			-- caps.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
			--
			-- require("lspconfig.util").default_config =
			-- 	vim.tbl_deep_extend("force", require("lspconfig.util").default_config, { capabilities = caps })
		end,
	},
}
