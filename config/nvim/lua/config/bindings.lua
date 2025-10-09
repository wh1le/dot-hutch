vim.g.mapleader = ";"

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	noremap = true,
	silent = true,
	desc = "Yank to system clipboard",
})

-- TODO: marks not working by default, investigate why and remove hotkey definition
-- Set 'm' to set a mark in normal mode
vim.keymap.set("n", "m", "m", { desc = "Set mark" })
-- Jump to mark with "'"
vim.keymap.set("n", "'", "'", { desc = "Jump to mark line" })
-- Jump to mark with "`"
vim.keymap.set("n", "`", "`", { desc = "Jump to mark position" })

-- Navigation and movement
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")
vim.keymap.set("", "<Space>", "/")
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { silent = true })

vim.keymap.set({ "n", "x", "s", "o" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "x", "s", "o" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "x", "s", "o" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "x", "s", "o" }, "<C-l>", "<C-w>l")

-- Buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

-- Windows
vim.keymap.set("n", "<C-w>f", "<C-w>_<C-w>|") -- focus
-- vim.keymap.set("n", "<C-w>f", ":only<CR>") -- focus

-- Exit
vim.keymap.set("n", "<leader>q", NM.quit.with_prompt, { silent = true, desc = "Quit (confirm)" })

-- Toggle test file
vim.keymap.set("n", "<leader>ta", function()
	NM.tests.toggle()
end, { desc = "Toggle test file" })
