return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = 'luasnip' },
          { name = "path" },
          { name = "buffer" },
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          -- ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
      })

      --
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern  = { "guihua", "guihua_rust" },
      --   callback = function() require("cmp").setup.buffer({ enabled = false }) end,
      -- })
    end,
  },
}
