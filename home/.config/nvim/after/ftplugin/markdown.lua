vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
