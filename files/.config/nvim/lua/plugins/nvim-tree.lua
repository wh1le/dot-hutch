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
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    -- 🧵 BOLD FOLDERS
    local hl = vim.api.nvim_set_hl
    hl(0, "NvimTreeFolderName",   { bold = true })   -- folder text
    hl(0, "NvimTreeOpenedFolderName", { bold = true }) -- opened folder text
    hl(0, "NvimTreeFolderIcon",   { bold = true })   -- folder icon
  end,
}
