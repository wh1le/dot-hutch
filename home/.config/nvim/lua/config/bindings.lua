vim.g.mapleader = ";"

-- TODO: marks 
-- vim.keymap.set("n", "m", "m", { desc = "Set mark" })
-- vim.keymap.set("n", "'", "'", { desc = "Jump to mark line" })
-- vim.keymap.set("n", "`", "`", { desc = "Jump to mark position" })

-- Navigation and movement
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")
vim.keymap.set("", "<Space>", "/")
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { silent = true })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers
-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")
-- vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

-- Windows
vim.keymap.set("n", "<C-w>z", "<C-w>_<C-w>|") -- focus
vim.keymap.set("n", "<C-w>f", ":only<CR>") -- focus

-- Exit
vim.keymap.set("n", "<leader>q", NM.quit.with_prompt, { silent = true, desc = "Quit (confirm)" })

-- Disable <leader>t timeout showing :tabs
vim.keymap.set("n", "<leader>t", "<Nop>")
