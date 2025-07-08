return {
  -- 📡  LSP core
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",         -- ⬅️ mason core
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",            -- caps before config()
    },

    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "tsserver", "bashls", "clangd", "ruby_lsp"
        },
        automatic_installation = true,
      })

      for _, srv in ipairs(mason_lsp.get_installed_servers()) do
        require("lspconfig")[srv].setup({
          on_attach    = on_attach,
          capabilities = capabilities,
        })
      end

      local lspconfig   = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      ---@param _ any  ---@param bufnr integer
      local function on_attach(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
        end
        map("K",          vim.lsp.buf.hover,        "Hover docs")
        map("gd",         vim.lsp.buf.definition,   "Go to def")
        map("gr",         vim.lsp.buf.references,   "Refs")
        map("<leader>rn", vim.lsp.buf.rename,       "Rename")
        map("<leader>ca", vim.lsp.buf.code_action,  "Code action")
        map("[d",         vim.diagnostic.goto_prev, "Prev diag")
        map("]d",         vim.diagnostic.goto_next, "Next diag")
      end

      -- one-liner handler + per-server overrides
      require("mason-lspconfig").setup_handlers({
        function(server)           -- default
          lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
        end,

        lua_ls = function()        -- custom example
          lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                workspace   = { checkThirdParty = false },
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,
      })
    end,
  },

  -- 💬  Autocompletion (optional but nice)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          { name = "buffer"   },
          { name = "path"     },
        }),
      })
    end,
  },
}
