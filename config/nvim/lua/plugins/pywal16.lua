return {
	"uZer/pywal16.nvim",
	config = function()
		vim.cmd.colorscheme("pywal16")

		local uv = vim.loop
		local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")
		local h = uv.new_fs_event()
		h:start(wal_file, {}, function()
			vim.schedule(function()
				vim.cmd([[colorscheme pywal16]])
			end)
		end)
	end,
}
