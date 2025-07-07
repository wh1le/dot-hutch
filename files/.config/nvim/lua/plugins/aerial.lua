return {
  'stevearc/aerial.nvim',
  opts = {
    keymaps = {
    },
      layout = {
      default_direction = "left",
    },
  },
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
  },
  config = function(_, opts)
    require("aerial").setup(opts)

    -- ✅ Define toggle mapping globally
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", {
      desc = "Toggle Aerial outline"
    })
  end,
}
