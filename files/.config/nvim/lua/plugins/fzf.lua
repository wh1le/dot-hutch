return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    winopts = {
      fullscreen = true,
      treesitter = {
        enabled   = true,
        fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" }
      },
    },
    keymap = {
      builtin = {
        ["<C-f>"] = "preview-page-down",
        ["<C-b>"] = "preview-page-up",
      },
    },
  },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>",      desc = "FZF: Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>",  desc = "FZF: Live Grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>",    desc = "FZF: Buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>",  desc = "FZF: Help Tags" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>",   desc = "FZF: Old Files" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>",    desc = "FZF: Keymaps" },
    { "<leader>fm", "<cmd>FzfLua marks<cr>",      desc = "FZF: Marks" },
    { "<leader>fc", "<cmd>FzfLua commands<cr>",   desc = "FZF: Commands" },
    { "<leader>ft", "<cmd>FzfLua tags<cr>",       desc = "FZF: Tags" },
    { "<leader>fr", "<cmd>FzfLua resume<cr>",     desc = "FZF: Resume Last Picker" },
  }
}
