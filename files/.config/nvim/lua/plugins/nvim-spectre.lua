return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Replace (project)" },
    { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Replace (file)" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, mode = { "n", "v" }, desc = "Replace word/selection" },
  },
  opts = {
    live_update = true,         -- live preview
    result_padding = " ",       -- cleaner UI
    color_devicons = false,     -- keep it minimal
  },
}
