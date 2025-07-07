return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  opts = {
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
      side = "right",
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false, -- false == show dotfiles
    },
  },
  keys = {
    { "<leader><leader>", function() require("nvim-tree.api").tree.toggle() end, desc = "Toggle NvimTree" },
  },
}
