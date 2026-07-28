-- Navigation and movement
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")
vim.keymap.set("", "<Space>", "/")
vim.keymap.set("", "<C-Space>", "?")
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { silent = true })

-- Buffers
vim.keymap.set("n", "<leader>bd", ":Bclose<CR>:tabclose<CR>gT")
vim.keymap.set("n", "<leader>ba", ":bufdo bd<CR>")
vim.keymap.set("n", "<leader>l", ":bnext<CR>")
vim.keymap.set("n", "<leader>h", ":bprevious<CR>")

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
vim.keymap.set("n", "<leader>to", ":tabonly<CR>")
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")
vim.keymap.set("n", "<leader>tm", ":tabmove ")
vim.keymap.set("n", "<leader>t<leader>", ":tabnext<CR>")

vim.g.lasttab = 1
vim.keymap.set("n", "<leader>tl", ':exe "tabn " .. vim.g.lasttab<CR>')
vim.api.nvim_create_autocmd("TabLeave", {
	pattern = "*",
	command = "let g:lasttab = tabpagenr()",
})

-- File helpers
vim.keymap.set("n", "<leader>te", ":tabedit %:p:h<CR>/")
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>")

-- Editing
vim.keymap.set("", "0", "^")
vim.keymap.set("n", "<M-j>", "mz:m+<CR>`z")
vim.keymap.set("n", "<M-k>", "mz:m-2<CR>`z")
vim.keymap.set("v", "<M-j>", ":m'>+<CR>`<my`>mzgv`yo`z")
vim.keymap.set("v", "<M-k>", ":m'<-2<CR>`>my`<mzgv`yo`z")
vim.keymap.set("n", "<D-j>", "<M-j>")
vim.keymap.set("n", "<D-k>", "<M-k>")
vim.keymap.set("v", "<D-j>", "<M-j>")
vim.keymap.set("v", "<D-k>", "<M-k>")

-- Visual replace
vim.keymap.set("v", "<leader>r", ':<C-u>call VisualSelection("replace", "")<CR>', { silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>cc", ":botright cope<CR>")
vim.keymap.set("n", "<leader>co", "ggVGy:tabnew<CR>:set syntax=qf<CR>pgg")
vim.keymap.set("n", "<leader>n", ":cn<CR>")
vim.keymap.set("n", "<leader>p", ":cp<CR>")

-- Remove ^M characters
vim.keymap.set("n", "<leader>m", "mmHmt:%s/\\r//ge<CR>'tzt'm", { noremap = true })

-- TODO: Delete: Toggle paste mode
-- vim.keymap.set("n", "<leader>pp", ":setlocal paste!<CR>")

-- Window nav
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- TODO  Delete old copy paste
-- vim.keymap.set("v", "<leader>y", ":w! ~/.vbuf<CR>")
-- vim.keymap.set("n", "<leader>y", ":.w! ~/.vbuf<CR>")
-- vim.keymap.set('n', '<leader>r', ':r ~/.vbuf<CR>') -- optional paste from buffer file

-- TODO Delete old: Buffer nav
-- vim.keymap.set("n", "<leader>p", ":bp<CR>")
-- vim.keymap.set("n", "<leader>n", ":bn<CR>")
-- vim.keymap.set("n", "<leader>d", ":bd<CR>")

-- copy to clipboard (normal + visual)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	noremap = true,
	silent = true,
	desc = "Yank to system clipboard",
})

-- (Past into console)
vim.keymap.set("c", "<C-y>", "<C-r>0", { noremap = true, silent = true, desc = "Paste last yank" })

-- (exit terminal)
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", {buffer = true, silent = true})
vim.keymap.set("n", "<C-x>", ":startinsert<CR>", {buffer = true, silent = true})
