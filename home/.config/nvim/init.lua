NM = {}

require("helpers.os")
require("helpers.path")
require("helpers.tests")
require("helpers.language_providers")
require("helpers.lazy")
require("helpers.quit")
require("helpers.statusline")
require("helpers.create_file")
require("helpers.colors")
require("helpers.lualine-config")

require("config.system_providers")
require("config.core")
require("config.bindings")
require("config.callbacks")
require("config.copypaste")
require("config.spell")
require("config.system_notifications")

require("config.lsp")
-- require("config.lsp.typescript")
-- require("config.lsp.json_ls")

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

vim.defer_fn(function()
	vim.cmd([[colorscheme pywal16]])
end, 10)

vim.opt.termguicolors = true

vim.g.kitty_fast_forwarded_modifiers = true
