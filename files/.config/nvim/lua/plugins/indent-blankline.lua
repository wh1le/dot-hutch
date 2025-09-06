return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = {
      char = "⋅",
      tab_char = "⋅"
      -- char = "•",
      -- tab_char = "•"
    },
    scope = {
      enabled = false
    },
  },
}
