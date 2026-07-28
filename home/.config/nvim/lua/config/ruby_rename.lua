-- Ruby class/file rename utility
-- Renames: file, class constant, spec file, and all references in project

local M = {}

-- Convert between naming conventions
local function to_class_name(str)
	-- auth_command -> AuthCommand
	return str:gsub("^%l", string.upper):gsub("_%l", function(s)
		return s:sub(2):upper()
	end)
end

local function to_file_name(str)
	-- AuthCommand -> auth_command
	return str:gsub("(%u)", function(s)
		return "_" .. s:lower()
	end):gsub("^_", "")
end

-- Find spec file for a given source file
local function find_spec_file(source_path)
	-- app/commands/auth.rb -> spec/commands/auth_spec.rb
	local spec_path = source_path
		:gsub("^app/", "spec/")
		:gsub("^lib/", "spec/lib/")
		:gsub("%.rb$", "_spec.rb")
	return spec_path
end

-- Find source file for a given spec file
local function find_source_file(spec_path)
	local source_path = spec_path:gsub("^spec/", "app/"):gsub("^spec/lib/", "lib/"):gsub("_spec%.rb$", ".rb")
	return source_path
end

-- Get project root (looks for Gemfile or .git)
local function get_project_root()
	local markers = { "Gemfile", ".git" }
	local path = vim.fn.expand("%:p:h")
	while path ~= "/" do
		for _, marker in ipairs(markers) do
			if vim.fn.filereadable(path .. "/" .. marker) == 1 or vim.fn.isdirectory(path .. "/" .. marker) == 1 then
				return path
			end
		end
		path = vim.fn.fnamemodify(path, ":h")
	end
	return vim.fn.getcwd()
end

-- Main rename function
function M.rename_ruby_class()
	local current_file = vim.fn.expand("%:p")
	local project_root = get_project_root()
	local relative_path = current_file:gsub("^" .. vim.pesc(project_root) .. "/", "")

	-- Extract current class name from file
	local current_file_name = vim.fn.expand("%:t:r") -- auth or auth_spec
	local is_spec = current_file_name:match("_spec$")
	if is_spec then
		current_file_name = current_file_name:gsub("_spec$", "")
	end
	local current_class_name = to_class_name(current_file_name)

	-- Prompt for new name
	vim.ui.input({ prompt = "New class name (e.g., AuthCommand): ", default = current_class_name }, function(new_class_name)
		if not new_class_name or new_class_name == "" or new_class_name == current_class_name then
			vim.notify("Rename cancelled", vim.log.levels.INFO)
			return
		end

		local new_file_name = to_file_name(new_class_name)

		-- Calculate paths
		local old_source, new_source, old_spec, new_spec

		if is_spec then
			old_spec = current_file
			new_spec = current_file:gsub(current_file_name .. "_spec%.rb$", new_file_name .. "_spec.rb")
			old_source = project_root .. "/" .. find_source_file(relative_path)
			new_source = old_source:gsub(current_file_name .. "%.rb$", new_file_name .. ".rb")
		else
			old_source = current_file
			new_source = current_file:gsub(current_file_name .. "%.rb$", new_file_name .. ".rb")
			old_spec = project_root .. "/" .. find_spec_file(relative_path)
			new_spec = old_spec:gsub(current_file_name .. "_spec%.rb$", new_file_name .. "_spec.rb")
		end

		-- Confirmation
		local changes = {
			string.format("Class: %s -> %s", current_class_name, new_class_name),
		}
		if vim.fn.filereadable(old_source) == 1 then
			table.insert(changes, string.format("Source: %s -> %s", vim.fn.fnamemodify(old_source, ":~:."), vim.fn.fnamemodify(new_source, ":~:.")))
		end
		if vim.fn.filereadable(old_spec) == 1 then
			table.insert(changes, string.format("Spec: %s -> %s", vim.fn.fnamemodify(old_spec, ":~:."), vim.fn.fnamemodify(new_spec, ":~:.")))
		end
		table.insert(changes, "")
		table.insert(changes, "This will also update all references in the project.")
		table.insert(changes, "Continue? (y/n)")

		vim.ui.input({ prompt = table.concat(changes, "\n") .. " " }, function(confirm)
			if confirm ~= "y" then
				vim.notify("Rename cancelled", vim.log.levels.INFO)
				return
			end

			-- Save all buffers first
			vim.cmd("wall")

			local renamed_files = {}

			-- 1. Rename source file
			if vim.fn.filereadable(old_source) == 1 and old_source ~= new_source then
				vim.fn.rename(old_source, new_source)
				table.insert(renamed_files, { old = old_source, new = new_source })
			end

			-- 2. Rename spec file
			if vim.fn.filereadable(old_spec) == 1 and old_spec ~= new_spec then
				vim.fn.rename(old_spec, new_spec)
				table.insert(renamed_files, { old = old_spec, new = new_spec })
			end

			-- 3. Update class name in all ruby files using sed
			local sed_cmd = string.format(
				"find %s -type f \\( -name '*.rb' -o -name '*.erb' \\) -exec sed -i 's/\\b%s\\b/%s/g' {} +",
				vim.fn.shellescape(project_root),
				current_class_name,
				new_class_name
			)
			vim.fn.system(sed_cmd)

			-- 4. Reload buffers
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local buf_name = vim.api.nvim_buf_get_name(buf)
					-- Check if this buffer was renamed
					for _, renamed in ipairs(renamed_files) do
						if buf_name == renamed.old then
							vim.api.nvim_buf_set_name(buf, renamed.new)
							vim.api.nvim_buf_call(buf, function()
								vim.cmd("edit!")
							end)
							break
						end
					end
					-- Reload other ruby files that might have changed
					if buf_name:match("%.rb$") or buf_name:match("%.erb$") then
						vim.api.nvim_buf_call(buf, function()
							vim.cmd("checktime")
						end)
					end
				end
			end

			-- Open the new source file if we're not already there
			if vim.fn.expand("%:p") ~= new_source and vim.fn.filereadable(new_source) == 1 then
				vim.cmd("edit " .. vim.fn.fnameescape(new_source))
			end

			vim.notify(string.format("Renamed %s to %s", current_class_name, new_class_name), vim.log.levels.INFO)
		end)
	end)
end

-- Create user command
vim.api.nvim_create_user_command("RubyRename", M.rename_ruby_class, {
	desc = "Rename Ruby class, file, spec, and all references",
})

return M
