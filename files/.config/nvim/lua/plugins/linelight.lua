return {
  {
    "junegunn/limelight.vim",
    cmd = { "Limelight", "LimelightEnable", "LimelightDisable" },
    init = function()
      vim.g.limelight_paragraph_span = 1
      vim.g.limelight_priority = -1
      vim.g.limelight_conceal_guifg = '#83a598'
      vim.g.limelight_conceal_ctermfg = 243   -- ≈ #767676
      vim.g.limelight_conceal_ctermbg = "NONE" -- keep your transparent bg
      vim.g.limelight_default_coefficient = 0.7
    end,
    keys = {
      { "<leader>L", "<cmd>Limelight 0.7<cr>", desc = "Limelight 0.7" },
    },
  },
}
