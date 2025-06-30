return {
  "jeetsukumaran/vim-buffergator",
  init = function()
    vim.g.buffergator_viewport_split_policy = "B"
    vim.g.buffergator_split_size = "10"
    vim.g.buffergator_display_regime = "bufname"
  end,
}
