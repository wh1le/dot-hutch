return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = { enable = true },
        move = { enable = true },
      },
    })
  end,
}
