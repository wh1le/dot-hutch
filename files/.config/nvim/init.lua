require("config.core")
require("config.helpers")
require("config.hotkeys")
require("config.copypaste")
require("config.fzf")
require("config.statusline")

require("lazy_setup")

local is_wsl = vim.fn.has("wsl") == 1

-- vim.opt.completeopt = "menu,menuone,noselect"

vim.g.perl_host_prog = '/usr/local/bin/perl'
vim.g.python_host_prog = '/usr/bin/python2'
if is_wsl then
  vim.g.python3_host_prog = '/usr/bin/python3'
else
  vim.g.python3_host_prog = '/Users/nikitamiloserdov/.venvs/nvim/bin/python3'
end
vim.g.ruby_host_prog = vim.fn.expand('~/.rbenv/versions/3.3.1/bin/ruby')
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

-- General settings
vim.o.showmode = false
vim.o.cursorline = false
vim.o.number = true
vim.o.relativenumber = false
vim.o.autoread = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Colorscheme
-- vim.cmd('colorscheme yang')
-- vim.cmd('colorscheme yang')
vim.o.termguicolors = true
vim.o.background = "light"

vim.cmd('highlight Normal guibg=NONE')

vim.opt.lazyredraw = true
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.visualbell = false
vim.opt.relativenumber = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
-- vim.opt.ttyscroll = 3
vim.opt.scrolloff = 0
vim.opt.incsearch = false

vim.cmd("highlight clear")
vim.api.nvim_set_hl(0, "Normal", { fg = "#000000", bg = "NONE" })

-- require("config/kill_green")

local hl = vim.api.nvim_set_hl

-- ✨ FOR TREESITTER (functions & methods)
hl(0, "@function", { bold = true })
hl(0, "@method", { bold = true })
hl(0, "@lsp.type.function", { bold = true })
hl(0, "@lsp.type.method", { bold = true })

-- 🏫 CLASSES / TYPES
hl(0, "@type", { bold = true })
hl(0, "@class", { bold = true })
hl(0, "@lsp.type.class", { bold = true })

-- 🧪 CONSTRUCTORS
hl(0, "@constructor", { bold = true })
hl(0, "@lsp.type.constructor", { bold = true })

-- ✨ FOR AERIAL (if using)
hl(0, "AerialFunction", { bold = true })
hl(0, "AerialMethod", { bold = true })

-- 🧬 STRUCTS / ENUMS / INTERFACES
hl(0, "@struct", { bold = true })
hl(0, "@enum", { bold = true })
hl(0, "@interface", { bold = true })

-- 📦 AERIAL
hl(0, "AerialFunction", { bold = true })
hl(0, "AerialMethod", { bold = true })
hl(0, "AerialClass", { bold = true })
hl(0, "AerialConstructor", { bold = true })

-- 📁 NVIM-TREE
hl(0, "NvimTreeFolderName", { bold = true })
hl(0, "NvimTreeOpenedFolderName", { bold = true })
hl(0, "NvimTreeFolderIcon", { bold = true })

local function set_sl_palette()
  local fg, bg = "#FFFFFF", "#000000"

  -- core groups
  vim.cmd(("hi! StatusLine   guifg=%s guibg=%s gui=NONE"):format(fg, bg))
  vim.cmd(("hi! StatusLineNC guifg=%s guibg=%s gui=NONE"):format(fg, bg))

  -- nvim-tree overrides its own groups → relink
  vim.cmd [[
    hi! link NvimTreeStatusLine    StatusLine
    hi! link NvimTreeStatusLineNC  StatusLineNC
  ]]

  -- aerial uses normal StatusLine; nothing extra
end

set_sl_palette() -- run once at startup

