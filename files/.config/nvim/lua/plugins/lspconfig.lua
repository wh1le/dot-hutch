return {
  -- 📡  LSP core
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    init = function()

			-- require("lspconfig").ruff.setup({
			-- 	cmd = { vim.fn.expand("~/.local/bin/ruff"), "server", "--preview" },
			-- })
			-- local lspconfig = require('lspconfig')
			-- lspconfig.ruby_lsp.setup({})
			-- lspconfig.pyright.setup({})
			-- lspconfig.ts_ls.setup({})

      local defaults = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, b)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = b, desc = desc })
          end
          map("K",  vim.lsp.buf.hover,        "Hover docs")
          map("gd", vim.lsp.buf.definition,   "Go to def")
          map("gr", vim.lsp.buf.references,   "Refs")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          -- map("[d", vim.diagnostic.goto_prev, "Prev diag")
          -- map("]d", vim.diagnostic.goto_next, "Next diag")
        end,
      }

      -- apply defaults to every server
      vim.lsp.config("*", defaults)

      -- per-server override
      vim.lsp.config("lua_ls", vim.tbl_deep_extend("force", defaults, {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "require" } },
            workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry   = { enable = false },
          },
        },
      }))
    end,
  },
}
