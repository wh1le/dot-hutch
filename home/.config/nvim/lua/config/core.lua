vim.deprecate = function() end

vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false

vim.o.mouse = "a"
vim.o.ttimeoutlen = 50
NM.foldexpr = require("helpers.foldexpr")
NM.foldtext = require("helpers.foldtext")
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.NM.foldexpr(v:lnum)"
vim.o.foldtext = "v:lua.NM.foldtext()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldminlines = 0
vim.o.swapfile = false
vim.o.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
vim.o.history = 2000
vim.o.binary = true
vim.o.endofline = false
vim.o.laststatus = 2
vim.o.wrap = false
vim.o.readonly = false
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"
vim.o.smartcase = true
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.timeoutlen = 500
vim.o.backup = false
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.hlsearch = true
vim.o.conceallevel = 0

vim.o.numberwidth = 1
vim.o.showmatch = true

-- General settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.o.showmode = false
vim.o.autoread = true
vim.o.number = true
vim.o.writebackup = false
vim.o.showtabline = 2

vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.visualbell = false
-- vim.opt.relativenumber = true
-- vim.opt.ttyscroll = 3
vim.opt.incsearch = false

vim.o.fileformat = "unix"
-- vim.o.fileformats = "mac"
-- end
