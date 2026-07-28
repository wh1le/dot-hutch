return {
	"mbrea-c/wal-colors.nvim",
	enabled = false,
	config = function()
		vim.cmd([[colorscheme mbc]])

		-- subscribe to file change
		local uv = vim.loop
		local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")
		local h = uv.new_fs_event()
		h:start(wal_file, {}, function()
			vim.schedule(function()
				vim.cmd([[colorscheme mbc]])
			end)
		end)
	end,
	priority = 1000,
}
