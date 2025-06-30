-- Key mapping for CtrlSF search
vim.keymap.set('n', '<leader>g', ':CtrlSF ', { noremap = true })

-- CtrlSF settings
vim.g.ctrlsf_auto_close = {
  normal = 0,
  compact = 0,
}

vim.g.ctrlsf_auto_focus = {
  at = "start",
}

vim.g.ctrlsf_context = "-B 1 -A 2"
vim.g.ctrlsf_winsize = "45%"
