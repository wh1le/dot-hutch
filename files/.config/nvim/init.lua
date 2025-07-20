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

-- Move to separate file
local M = {}

local function in_spec(path)
	return path:match("^spec/")
end

local M = {}

function M.toggle()
	local abs = vim.api.nvim_buf_get_name(0)
	if abs == "" then
		return
	end

	-- path relative to the cwd (assumed repo root)
	local rel = vim.fn.fnamemodify(abs, ":.")

	local target
	if in_spec(rel) then
		target = rel:gsub("^spec/", ""):gsub("_spec%.rb$", ".rb")
		-- everything except lib/ lives in app/
		if not target:match("^lib/") then
			target = "app/" .. target
		end
	else
		-- strip optional app/ prefix before building the spec path
		target = rel:gsub("^app/", ""):gsub("%.rb$", "_spec.rb")
		target = "spec/" .. target
	end

	vim.cmd.edit(target)
end

-- init.lua (or any file sourced at startup)
vim.keymap.set("n", "<leader>ta", M.toggle, { desc = "Toggle source ⇄ spec", silent = true })
-- Move to separate file
