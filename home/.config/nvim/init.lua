NM = {}

require("helpers.os")
-- require("helpers.tests")
require("helpers.language_providers")
require("helpers.lazy")
require("helpers.quit")
require("helpers.statusline")
require("helpers.create_file")
require("helpers.lualine-config")

require("config.system_providers")
require("config.core")
require("config.bindings")
require("config.callbacks")
require("config.copypaste")
require("config.spell")
require("config.system_notifications")
require("config.lsp")

NM.lazy.setup()

vim.cmd("filetype plugin indent on")

vim.api.nvim_create_augroup("NoConcealJSON", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "NoConcealJSON",
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.conceallevel = 0
	end,
})

vim.opt.scrolloff = 8

vim.opt.termguicolors = false
vim.g.kitty_fast_forwarded_modifiers = true

vim.cmd("hi Normal ctermfg=NONE ctermbg=NONE")
vim.cmd("hi SignColumn ctermbg=NONE")
vim.cmd("hi LineNr ctermfg=8")
vim.cmd("hi Comment ctermfg=8")
vim.cmd("hi Visual ctermbg=8")

vim.cmd("colorscheme noctu")
