-- Create file under cursor if it doesn't exist when using gf
vim.keymap.set("n", "gf", function()
	local cfile = vim.fn.expand("<cfile>")

	vim.opt.isfname:remove("=")

	local ok, err = pcall(function()
		vim.cmd("normal! gf")
	end)

	if not ok and err:match("E447") then -- E447: Can't find file in path
		local file = vim.fn.expand(cfile) -- Get the full path as Vim resolved it

		if not file:match("^[/~$]") then
			local current_dir = vim.fn.expand("%:p:h")
			file = current_dir .. "/" .. file
		end

		file = vim.fn.expand(file) -- Expand any remaining env vars or ~
		file = vim.fn.fnamemodify(file, ":p") -- Normalize the path (resolve ../ etc)

		local prompt = string.format('File "%s" does not exist. Create it?', file)

		local choice = vim.fn.confirm(prompt, "&Yes\n&No", 1)

		if choice == 1 then
			local dir = vim.fn.fnamemodify(file, ":h")
			if vim.fn.isdirectory(dir) == 0 then
				vim.fn.mkdir(dir, "p")
			end

			vim.cmd("edit " .. vim.fn.fnameescape(file))
		end
	elseif not ok then
		-- Some other error, re-raise it
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Go to file (create if missing)" })
