-- Auto-reload changed files
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime"
})

-- Prevent formatoptions reset on focus or mode change
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime"
})

vim.api.nvim_create_autocmd("BufRead", {
  command = "set formatoptions-=cro"
})

vim.api.nvim_create_autocmd("BufReadPre", {
  command = "setlocal fileformat=unix"
})

-- Show message when shell changes the file
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]]
})

