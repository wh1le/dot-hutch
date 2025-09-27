return {
  "junegunn/vim-easy-align",
  cmd = { "EasyAlign" },
  keys = {
    -- interactive (operator + visual)
    { "<leader>ca", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign: interactive" },

    -- one-shot (visual selections)
    -- { "<leader>c=", ":EasyAlign /=/<CR>",  mode = "x", desc = "Align =" },
    -- { "<leader>c:", ":EasyAlign /:/<CR>",  mode = "x", desc = "Align :" },
    -- { "<leader>c,", ":EasyAlign /,/<CR>",  mode = "x", desc = "Align ," },
    -- { "<leader>c|", ":EasyAlign /\\|/<CR>",mode = "x", desc = "Align |" },
    -- { "<leader>cs", ":EasyAlign /\\s\\+/<CR>", mode = "x", desc = "Align whitespace" },
    -- { "<leader>c/", ":EasyAlign /",        mode = "x", desc = "Align by regex…" },
  },
}
