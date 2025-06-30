-- Basics vim.o.clipboard = 'unnamedplus' -- Uncomment to use system clipboard
vim.o.mouse = 'a'
vim.o.ttimeoutlen = 50
vim.o.foldlevel = 99
vim.o.swapfile = false
vim.o.encoding = 'UTF-8'
vim.o.fileencoding = 'utf-8'
vim.o.history = 2000
vim.o.fileformats = 'mac,unix'
vim.o.fileformat = 'unix'
vim.o.binary = true
vim.o.endofline = false
vim.o.laststatus = 2
vim.o.wrap = false
vim.o.readonly = false
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.whichwrap = vim.o.whichwrap .. '<,>,h,l'
vim.o.smartcase = true
vim.o.lazyredraw = true
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.timeoutlen = 500
vim.o.backup = false
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.cursorcolumn = false
vim.o.cursorline = false
vim.o.hlsearch = true
vim.o.conceallevel = 3

-- TUI
vim.o.numberwidth = 4
vim.o.showtabline = 0
vim.o.scrolloff = 8
vim.o.showmatch = true

-- Colors
vim.g.base16colorspace = 256
vim.cmd('syntax sync minlines=256')

vim.cmd [[
  hi htmlArg cterm=italic
  hi Comment cterm=italic
  hi Type cterm=italic
  highlight Comment cterm=italic gui=italic
  hi Function cterm=bold
]]
