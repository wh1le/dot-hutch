return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- "hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
      vim.opt.pumheight = 10

			cmp.setup({
				sources = {
					{ name = "nvim_lsp", max_item_count = 10  },
					{ name = "luasnip", max_item_count = 10 },
					{ name = "path", max_item_count = 10 },
					{ name = "buffer", max_item_count = 10 },
				},
        window = {
          completion = require('cmp').config.window.bordered(),
          documentation = require('cmp').config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				-- mapping = cmp.mapping.preset.insert({
				-- 	-- ["<C-Space>"] = cmp.mapping.complete(),
				-- 	["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- 	["<Tab>"] = cmp.mapping.select_next_item(),
				-- 	["<S-Tab>"] = cmp.mapping.select_prev_item(),
				-- }),
			})
		end,
	},
}
