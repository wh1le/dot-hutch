vim.g.mapleader = ","

require("config.core")
require("config.helpers")
-- require("config.hotkeys")
require("config.copypaste")
require("config.statusline")
require("lazy_setup")

local is_wsl = vim.fn.has("wsl") == 1

vim.g.perl_host_prog = "/usr/local/bin/perl"
vim.g.python_host_prog = "/usr/bin/python2"
if is_wsl then
	vim.g.python3_host_prog = "/usr/bin/python3"
else
	vim.g.python3_host_prog = "/Users/nikitamiloserdov/.venvs/nvim/bin/python3"
end
vim.g.ruby_host_prog = vim.fn.expand("~/.rbenv/versions/3.3.1/bin/ruby")
vim.g.loaded_perl_provider = 0

require("config/colors")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	noremap = true,
	silent = true,
	desc = "Yank to system clipboard",
})

local open_cmd = (vim.fn.has("mac") == 1 and "open")
	or (vim.fn.executable("wslview") == 1 and "wslview")
	or (vim.fn.executable("xdg-open") == 1 and "xdg-open")
	or nil

if open_cmd then
	vim.g.netrw_browsex_viewer = open_cmd -- for legacy :NetrwBrowseX
	vim.ui.open = function(path)
		vim.fn.jobstart({ open_cmd, path }, { detach = true })
	end
else
	vim.notify("No system opener found for gx", vim.log.levels.ERROR)
end
