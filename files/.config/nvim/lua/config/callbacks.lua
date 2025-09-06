-- Auto-reload changed files
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

-- Prevent formatoptions reset on focus or mode change
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufRead", {
  command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd("BufReadPre", {
  command = "setlocal fileformat=unix",
})

-- Show message when shell changes the file
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]],
})

-- vim.keymap.set("n", "<leader>rr", function()
-- 	for name, _ in pairs(package.loaded) do
-- 		if name:match("^user") or name:match("^plugins") or name:match("^config") then
-- 			package.loaded[name] = nil
-- 		end
-- 	end
-- 	dofile(vim.fn.stdpath("config") .. "/init.lua")
-- 	print("🔁 Reloaded config")
-- end, { desc = "Reload config" })
