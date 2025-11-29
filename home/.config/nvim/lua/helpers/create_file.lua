-- Create file under cursor if it doesn't exist when using gf
vim.keymap.set("n", "gf", function()
	local file = vim.fn.expand("<cfile>")
	-- Expand environment variables like $HOME
	file = vim.fn.expand(file)

	-- If file doesn't exist, ask to create it
	if vim.fn.filereadable(file) == 0 then
		local choice = vim.fn.confirm(string.format('File "%s" does not exist. Create it?', file), "&Yes\n&No", 1)
		if choice == 1 then
			-- Create directory if it doesn't exist
			local dir = vim.fn.fnamemodify(file, ":h")
			if vim.fn.isdirectory(dir) == 0 then
				vim.fn.mkdir(dir, "p")
			end
			-- Create and open the file
			vim.cmd("edit " .. vim.fn.fnameescape(file))
		end
	else
		-- File exists, open it normally
		vim.cmd("normal! gf")
	end
end, { desc = "Go to file (create if missing)" })
