return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "ruby",
      "tsx",
      "html",
      "yaml",
      "toml",
      "bash",
      "dockerfile",
      "markdown",
      "gitcommit",
      "make",
    },
    highlight = {
      enable = true,
    },
    auto_install = true,
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- 🧠 Boldify function names in Treesitter + Aerial
    local hl = vim.api.nvim_set_hl
    hl(0, "@function", { bold = true })
    hl(0, "@method", { bold = true })
    hl(0, "@lsp.type.function", { link = "Function", bold = true })
    hl(0, "@lsp.type.method", { link = "Function", bold = true })

    hl(0, "AerialFunction", { bold = true })
    hl(0, "AerialMethod", { bold = true })
  end,
}
