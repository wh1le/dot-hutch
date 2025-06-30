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
}
