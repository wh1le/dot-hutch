local default_notify = function(msg, level, opts)
	default_notify(msg, level, opts)
	vim.fn.jobstart({ "notify-send", opts and "Neovim: " .. opts.title or "Neovim", msg })
end
