vim.g.mapleader = ";"

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	noremap = true,
	silent = true,
	desc = "Yank to system clipboard",
})

-- Navigation and movement
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")
vim.keymap.set("", "<Space>", "/")
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { silent = true })

-- Buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

-- Tabs
-- vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
-- vim.keymap.set("n", "<leader>tb", ":tabprev<CR>")
-- vim.keymap.set("n", "<leader>to", ":tabnew<CR>")
-- vim.keymap.set("n", "<leader>tf", ":tabonly<CR>")
-- vim.keymap.set("n", "<leader>td", ":tabclose<CR>")
-- vim.keymap.set("n", "<leader>tm", ":tabmove")
-- vim.keymap.set("n", "<leader>tO", "<C-w>T", { desc = "Move split to new tab" })

-- Windows
vim.keymap.set("n", "<C-w>f", "<C-w>_<C-w>|") -- focus
-- vim.keymap.set("n", "<C-w>f", ":only<CR>") -- focus

-- Exit
vim.keymap.set("n", "<leader>q", NM.quit.with_prompt, { silent = true, desc = "Quit (confirm)" })

-- Toggle test file
vim.keymap.set("n", "<leader>ta", function() NM.tests.toggle() end, { desc = "Toggle test file" })

