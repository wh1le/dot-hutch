return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- "hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		keys = {
			{
				"<C-b>",
				mode = "i",
				function()
					require("cmp").mapping.scroll_docs(-4)()
				end,
				desc = "CMP scroll docs up",
			},
			{
				"<C-f>",
				mode = "i",
				function()
					require("cmp").mapping.scroll_docs(4)()
				end,
				desc = "CMP scroll docs down",
			},
			{
				"<C-Space>",
				mode = "i",
				function()
					require("cmp").mapping.complete()()
				end,
				desc = "CMP trigger completion",
			},
			{
				"<C-e>",
				mode = "i",
				function()
					require("cmp").mapping.abort()()
				end,
				desc = "CMP abort completion",
			},
			{
				"<CR>",
				mode = "i",
				function()
					require("cmp").mapping.confirm({ select = true })()
				end,
				desc = "CMP confirm selection",
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- vim.opt.pumheight = 10

			cmp.setup({
				-- sources = {
				--   { name = "nvim_lsp", max_item_count = 10  },
				--   { name = "luasnip", max_item_count = 10 },
				--   { name = "path", max_item_count = 10 },
				--   { name = "buffer", max_item_count = 10 },
				-- },
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "nvim_lsp_signature_help" },
				},
				window = {
					completion = require("cmp").config.window.bordered(),
					documentation = require("cmp").config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- safe: noop if no docs
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand() -- expand snippet first ⏩
							else
								cmp.confirm({ select = true }) -- or accept completion item
							end
						else
							fallback() -- insert newline
						end
					end),

					------------------------------------------------------------------
					-- Tab gymnastics: menu > snippet > plain tab --------------------
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback() -- literally a <Tab>
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},
}
