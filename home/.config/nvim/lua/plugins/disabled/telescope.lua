return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6", -- or branch = "0.1.x"
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
  },
  cmd = "Telescope",
  keys = {
    -- 🔍 Search-focused mappings (Fast access)
    { "<leader>pp", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>pg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>pw", "<cmd>Telescope grep_string<cr>", desc = "Word Under Cursor" },
    { "<leader>pr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

    -- 🔭 Full Telescope namespace (organized)
    { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>tk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>tc", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>tm", "<cmd>Telescope marks<cr>", desc = "Marks" },

    { "<leader>tq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
    { "<leader>tj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },

    { "<leader>ts", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>tS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>td", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics (All)" },

    { "<leader>tG", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
    { "<leader>tC", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
    { "<leader>tB", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },

    -- Optional group names (shows in which-key as "+Find/Search", "+Telescope")
    { "<leader>f", desc = "+Find/Search" },
    { "<leader>t", desc = "+Telescope" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 10,
        previewer = false,
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Load extensions if available
    pcall(telescope.load_extension, "fzf")
  end,
}
