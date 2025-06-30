require("config.core")
require("config.helpers")
require("config.hotkeys")

require("lazy_setup")

-- vim.opt.completeopt = "menu,menuone,noselect"

vim.g.perl_host_prog = '/usr/local/bin/perl'
vim.g.python_host_prog = '/usr/bin/python2'
vim.g.python3_host_prog = '/Users/nikitamiloserdov/.venvs/nvim/bin/python3'
vim.g.ruby_host_prog = vim.fn.expand('~/.rbenv/versions/3.3.0/bin/ruby')
vim.g.loaded_perl_provider = 0

vim.o.termguicolors = true
vim.opt.signcolumn = "yes"

-- vim.cmd('syntax sync fromstart')

-- vim.g.UltiSnipsExpandTrigger = '<c-j>'

vim.o.wrap = false
vim.o.linebreak = true

vim.env.TERM = "tmux-256color"

-- vim.keymap.set('v', '<C-c>', '"+y')

-- vim.api.nvim_create_autocmd("BufReadCmd", {
--   pattern = "*.epub",
--   command = 'call zip#Browse(expand("<amatch>"))',
-- })

-- Colorscheme
vim.cmd('colorscheme kindlight_relax')

-- General settings
vim.o.showmode = false
vim.o.cursorline = false
vim.o.number = true
vim.o.relativenumber = false
vim.o.autoread = true
