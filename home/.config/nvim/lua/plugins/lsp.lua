NM.color = {}
NM.color.lighten = function(color, amount)
	if not color then
		return nil
	end
	local r = bit.rshift(bit.band(color, 0xFF0000), 16)
	local g = bit.rshift(bit.band(color, 0x00FF00), 8)
	local b = bit.band(color, 0x0000FF)
	r = math.min(255, r + amount)
	g = math.min(255, g + amount)
	b = math.min(255, b + amount)
	return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

NM.cmp = {}
NM.cmp.set_colors = function()
	local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
	local pmenu_sel = vim.api.nvim_get_hl(0, { name = "PmenuSel" })

	vim.api.nvim_set_hl(0, "CmpNormal", { bg = NM.color.lighten(normal_bg, 20) })
	vim.api.nvim_set_hl(0, "CmpDoc", { bg = NM.color.lighten(normal_bg, 15) })
	vim.api.nvim_set_hl(0, "CmpSel", { bg = pmenu_sel.bg, fg = pmenu_sel.fg })
end

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
		NM.ai_enabled and "zbirenbaum/copilot-cmp" or nil,
	},

	config = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }

		local cmp = require("cmp")
		require("lspkind")

		require("fidget").setup({
			suppress_on_insert = true,
		})

		NM.cmp.set_colors()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = NM.cmp.set_colors,
		})

		cmp.setup({
			experimental = {
				ghost_text = true,
			},
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,CursorLine:CmpSel",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:CmpDoc",
				}),
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
				{ name = "nvim_lsp" },
				{ name = "copilot" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
				-- NOTE: possible to use with all opened buffers but craches if open a big one
				-- option = {
				-- 	get_bufnrs = function()
				-- 		return vim.api.nvim_list_bufs()
				-- 	end,
				-- },
			}),
			-- formatting = {
			-- 	fields = { "abbr", "menu" },
			-- 	format = function(entry, vim_item)
			-- 		local source_icons = {
			-- 			nvim_lsp = "󰒍",
			-- 			copilot = "󰚩",
			-- 			luasnip = "󰩫",
			-- 			buffer = "󰈙",
			-- 			path = "󰉋",
			-- 			cmdline = "󰘳",
			-- 		}
			--
			-- 		local source = entry.source.name
			-- 		vim_item.menu = source_icons[source] or source
			--
			-- 		return vim_item
			-- 	end,
			-- },
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

		vim.keymap.set("n", "<leader>lh", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP health" })
		vim.keymap.set("n", "<leader>ll", function()
			vim.cmd("edit " .. vim.lsp.get_log_path())
		end, { desc = "LSP log" })
		vim.keymap.set("n", "<leader>lR", function()
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
				vim.lsp.stop_client(client.id)
			end
			vim.cmd("edit")
		end, { desc = "LSP restart" })

		vim.keymap.set("i", "<C-s>", function()
			require("cmp").complete()
		end, { desc = "Trigger completion" })

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
		vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })

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
