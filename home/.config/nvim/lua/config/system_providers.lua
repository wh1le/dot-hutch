-- 	return vim.fn.trim(vim.fn.exepath(name))

local open_file = function(path)
	local open_cmd_provider = function()
		if vim.fn.has("mac") == 1 then
			return "open"
		elseif vim.fn.executable("wslview") == 1 then
			return "wslview"
		elseif vim.fn.executable("xdg-open") == 1 then
			return "xdg-open"
		else
			vim.notify("No system opener found for gx", vim.log.levels.ERROR)
		end
	end

	vim.fn.jobstart({ open_cmd_provider(), path }, { detach = true })
end

vim.g.perl_host_prog = vim.fn.exepath("perl")
vim.g.python_host_prog = vim.fn.exepath("python2")
vim.g.python3_host_prog = vim.fn.exepath("python3")
vim.g.ruby_host_prog = vim.fn.exepath("ruby")

-- open file
vim.ui.open = open_file
