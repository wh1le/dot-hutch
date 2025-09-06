return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
		},
		-- keys = {
		-- 	{ "<C-b>", mode = "i", function() require("cmp").mapping.scroll_docs(-4)() end, desc = "CMP scroll docs up", },
		-- 	{ "<C-f>", mode = "i", function() require("cmp").mapping.scroll_docs(4)() end, desc = "CMP scroll docs down", },
		-- 	{ "<C-Space>", mode = "i", function() require("cmp").mapping.complete()() end, desc = "CMP trigger completion", },
		-- 	{ "<C-e>", mode = "i", function() require("cmp").mapping.abort()() end, desc = "CMP abort completion", },
		-- 	{ "<Tab>", mode = "i", function() require("cmp").mapping.confirm({ select = true })() end, desc = "CMP confirm selection", },
		-- },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
      local lspkind = require('lspkind')

			cmp.setup({
				performance = {
					debounce = 3000, -- ms to wait before showing / updating menu
					throttle = 150, -- (optional) how often to refresh while visible
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					-- { name = "nvim_lsp_signature_help" },
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
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = {
              menu = 50, -- leading text (labelDetails)
              abbr = 50, -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (entry, vim_item)
              -- ...
              return vim_item
            end
          })
        },

				mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item { behaviour = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behaviour = cmp.SelectBehavior.Insert },

					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- safe: noop if no docs
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping(function()
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand() -- expand snippet first
							else
								cmp.confirm({ select = true }) -- accept item (triggers snippet if snippet item)
							end
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump() -- jump inside snippet
						else
							-- local t = function(str)
							-- 	return vim.api.nvim_replace_termcodes(str, true, false, true)
							-- end
							-- vim.api.nvim_feedkeys(t("<Tab>"), "n", true) -- literal tab
						end
					end, { "i" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
						else
              fallback()
						end
					end, { "i" }),
				}),
			})
		end,
	},
}
