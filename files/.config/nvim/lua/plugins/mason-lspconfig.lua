return {
  "williamboman/mason-lspconfig.nvim",
  -- lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "pyright",
      "ts_ls",
      "bashls",
      "clangd",
      "ruby_lsp",
      "rubocop",
      "eslint",
      "ruff"
    },
    automatic_enable = true,
    handlers = {
      function(server)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local opts = {
          capabilities = capabilities,
        }

        require("lspconfig")[server].setup(opts)
      end,
    }
  },
}
