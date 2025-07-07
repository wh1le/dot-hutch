return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = { char = "┊", tab_char = "┊" }, -- pick any glyph
    scope  = { enabled = true },            -- no extra fluff
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = true
    }
  },
}
