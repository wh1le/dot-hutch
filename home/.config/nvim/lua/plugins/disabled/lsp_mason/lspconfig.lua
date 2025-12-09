return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	keys = {
		{"K", function() vim.lsp.buf.hover() end, desc = "Built-in: vim.lsp.buf.hover()", },
		{ "gd", function() vim.lsp.buf.definition() end, desc = "Go to def", },
		{ "gr", function() vim.lsp.buf.references() end, desc = "Ref", },
		-- { "<leader>rn", function() vim.lsp.buf.rename() end, desc = "Rename",
		},
    { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code action", },
		{ "<leader>de", function() vim.diagnostic.open_float( nil, { focus = false, border = "rounded", source = "always", scope = "cursor" }) end, desc = "Explain diagnostic under cursor", },
	},
	init = function()
		local defaults = {}
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

		vim.api.nvim_create_autocmd({ "UIEnter", "LspAttach", "ColorScheme" }, { callback = apply_diag_signs })
		vim.lsp.config("*", defaults)
    -- delay update diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false }
    )


		-- triggered with (
		-- vim.api.nvim_create_autocmd("InsertCharPre", {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		local char = vim.v.char
		-- 		if char == "(" or char == "," then
		-- 			vim.defer_fn(function()
    --         if c.server_capabilities.signatureHelpProvider then
    --           vim.lsp.buf.signature_help()
    --         end
		-- 			end, 0)
		-- 		end
		-- 	end,
		-- })

		-- vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach" }, {
		-- 	callback = function()
		-- 		-- local style = {
		-- 		--   fg = "#9CA3AF",      -- light gray
		-- 		--   bg = "NONE",
		-- 		--   italic = false,
		-- 		--   underline = false,
		-- 		--   strikethrough = false,
		-- 		--   nocombine = true,    -- ignore theme links
		-- 		-- }
		-- 		-- local groups = {
		-- 		--   "DiagnosticUnnecessary",
		-- 		--   "@lsp.mod.unused",
		-- 		--   "@lsp.typemod.variable.unused",
		-- 		--   "@lsp.typemod.parameter.unused",
		-- 		--   "@lsp.typemod.function.unused",
		-- 		--   "@lsp.typemod.method.unused",
		-- 		--   "@lsp.typemod.property.unused",
		-- 		--   "@lsp.typemod.enumMember.unused",
		-- 		-- }
		-- 		-- vim.api.nvim_set_hl(0, "DiagUnusedThing", { fg = "#9CA3AF", italic = false, nocombine = true })
    --
		-- 		-- for _, g in ipairs(groups) do
		-- 		--   pcall(vim.api.nvim_set_hl, 0, g, style)
		-- 		-- end
    --
		-- 		-- clean styles
				-- for _, g in ipairs({ "DiagnosticUnnecessary", "@lsp.mod.unused" }) do
				-- 	pcall(vim.api.nvim_set_hl, 0, g, { link = "Normal" })
				-- end
		-- 	end,
		-- })
	end,
}
