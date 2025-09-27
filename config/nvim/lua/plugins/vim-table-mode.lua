return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "rmd", "txt" }, -- load only where you write tables
  dependencies = { "godlygeek/tabular" }, -- safe/typical companion
  init = function()
    -- Markdown-style borders and header
    vim.g.table_mode_corner = "|"                 -- MD corners
    vim.g.table_mode_header_fillchar = "-"        -- MD header line
    vim.g.table_mode_align_char = ":"             -- use ':' for align hints
  end,
  keys = {
    { "<leader>cta", "<cmd>TableModeToggle<CR>",        desc = "Table: toggle mode (auto-align as you type)" },
    { "<leader>ct", "<cmd>TableModeRealign<CR>",       desc = "Table: realign current table" },
    { "<leader>ct|", "<cmd>Tableize /\\|<CR>",  mode = { "n", "x" }, desc = "Tableize by | (MD)" },
    { "<leader>ct,", "<cmd>Tableize /,<CR>",    mode = { "n", "x" }, desc = "Tableize by , (CSV)" },
    { "<leader>ct/", ":Tableize /",             mode = "x",          desc = "Tableize by custom regex…" },
  },
}
