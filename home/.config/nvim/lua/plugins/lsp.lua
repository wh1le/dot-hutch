return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		"j-hui/fidget.nvim",
	},

	config = function()
		-- conform is configured in lua/plugins/conform.lua

		local cmp = require("cmp")
		local lspkind = require("lspkind")

		require("fidget").setup({
			suppress_on_insert = true,
		})

		vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#1a1b26" })

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-a>"] = cmp.mapping.complete(),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
			}),

			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "buffer" },
				-- NOTE: possible to use with all opened buffers but craches if open a big one
				-- option = {
				-- 	get_bufnrs = function()
				-- 		return vim.api.nvim_list_bufs()
				-- 	end,
				-- },
			}),
			formatting = {
				fields = { "icon", "abbr", "menu" },
				-- format = lspkind.cmp_format({
				-- 	maxwidth = {
				-- 		menu = 50,
				-- 		abbr = 50,
				-- 	},
				-- 	ellipsis_char = "...",
				-- 	show_labelDetails = true,
				-- }),
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
			-- matching = { disallow_symbol_nonprefix_matching = false },
		})

		-- vim.diagnostic.config({
		-- 	-- underline = false,
		-- 	-- virtual_text = {
		-- 	--   severity = { min = vim.diagnostic.severity.WARN },
		-- 	-- 	current_line = true,
		-- 	-- }
		-- 	float = {
		-- 		focusable = false,
		-- 		style = "minimal",
		-- 		border = "rounded",
		-- 		-- source = "always",
		-- 		header = "",
		-- 		prefix = "",
		-- 	},
		-- })

		-- local function setup_diagnostics()
		-- 	local signs = { Error = "󰢱", Warn = "", Info = "»", Hint = "" }
		-- 	for type, icon in pairs(signs) do
		-- 		local hl = "DiagnosticSign" .. type
		-- 		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- 	end
		-- end
		--
		-- setup_diagnostics()

		require("config.lsp")

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
		vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
		vim.keymap.set("n", "<leader>de", function()
			vim.diagnostic.open_float(nil, {
				focus = false,
				border = "rounded",
				source = "always",
				scope = "cursor",
			})
		end, { desc = "Diagnostic explain" })
	end,
}
