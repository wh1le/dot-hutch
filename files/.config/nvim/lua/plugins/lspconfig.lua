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
			{
				"<leader>de",
				function()
					vim.diagnostic.open_float(nil, {
						focus = false,
						border = "rounded",
						source = "always",
						scope = "cursor",
					})
				end,
				desc = "Explain diagnostic under cursor",
			},
		},

		init = function()
			local defaults = {}
			local lspconfig = require("lspconfig")

			local signs = { Error = "󰢱", Warn = "", Info = "»", Hint = "" }
			local function apply_diag_signs()
				for typ, icon in pairs(signs) do
					local hl = "DiagnosticSign" .. typ
					vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
				end
				vim.diagnostic.config({
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = signs.Error,
							[vim.diagnostic.severity.WARN] = signs.Warn,
							[vim.diagnostic.severity.INFO] = signs.Info,
							[vim.diagnostic.severity.HINT] = signs.Hint,
						},
						numhl = false,
					},
					severity_sort = true,
					float = { border = "rounded", source = "always" },
				})
			end

			vim.api.nvim_create_autocmd({ "UIEnter", "LspAttach", "ColorScheme" }, {
				callback = apply_diag_signs,
			})

			-- vim.o.updatetime = 10000

			-- apply defaults to every server
			vim.lsp.config("*", defaults)

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

      vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach" }, {
        callback = function()
          -- local style = {
          --   fg = "#9CA3AF",      -- light gray
          --   bg = "NONE",
          --   italic = false,
          --   underline = false,
          --   strikethrough = false,
          --   nocombine = true,    -- ignore theme links
          -- }
          -- local groups = {
          --   "DiagnosticUnnecessary",
          --   "@lsp.mod.unused",
          --   "@lsp.typemod.variable.unused",
          --   "@lsp.typemod.parameter.unused",
          --   "@lsp.typemod.function.unused",
          --   "@lsp.typemod.method.unused",
          --   "@lsp.typemod.property.unused",
          --   "@lsp.typemod.enumMember.unused",
          -- }
          -- vim.api.nvim_set_hl(0, "DiagUnusedThing", { fg = "#9CA3AF", italic = false, nocombine = true })

          -- for _, g in ipairs(groups) do
          --   pcall(vim.api.nvim_set_hl, 0, g, style)
          -- end

          -- clean styles
          for _, g in ipairs({ "DiagnosticUnnecessary", "@lsp.mod.unused" }) do
            pcall(vim.api.nvim_set_hl, 0, g, { link = "Normal" })
          end
        end,
      })
		end,
	},
}
