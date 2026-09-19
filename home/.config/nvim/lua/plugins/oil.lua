-- Keep symlink paths instead of resolving them to their target.
local function no_symlink_resolve()
	local files = require("oil.adapters.files")
	local fs = require("oil.fs")
	local util = require("oil.util")
	local uv = vim.uv or vim.loop
	files.normalize_url = function(url, callback)
		local scheme, path = util.parse_url(url)
		assert(path)
		local os_path = vim.fn.fnamemodify(fs.posix_to_os_path(path), ":p")
		uv.fs_stat(
			os_path,
			vim.schedule_wrap(function(_, stat)
				local is_directory
				if stat then
					is_directory = stat.type == "directory"
				elseif vim.endswith(os_path, "/") or (fs.is_windows and vim.endswith(os_path, "\\")) then
					is_directory = true
				else
					local filetype = vim.filetype.match({ filename = vim.fs.basename(os_path) })
					is_directory = filetype == nil
				end

				if is_directory then
					callback(scheme .. util.addslash(fs.os_to_posix_path(os_path)))
				else
					callback(vim.fn.fnamemodify(os_path, ":."))
				end
			end)
		)
	end
end

return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = true,
		columns = {},
		use_default_keymaps = false,
		watch_for_changes = true,
		view_options = { show_hidden = true },
		keymaps = {
			["<CR>"] = { "actions.select", mode = "n" },
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		no_symlink_resolve()
	end,
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Oil: Open parent dir",
			mode = "n",
			silent = true,
		},
	},
	init = function()
		-- vim.g.loaded_netrw = 1
		-- vim.g.loaded_netrwPlugin = 1
	end,
}
