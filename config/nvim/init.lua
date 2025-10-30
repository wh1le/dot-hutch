NM = {}

require("helpers.os")
require("helpers.path")
require("helpers.tests")
require("helpers.language_providers")
require("helpers.lazy")
require("helpers.quit")
require("helpers.statusline")

require("config.system_providers")
require("config.core")
require("config.colors")
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
