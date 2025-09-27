return {
	"jeetsukumaran/vim-buffergator",
  keys = {
    { "<leader>bb", "<cmd>BuffergatorToggle<cr>", desc = "Buffers (Buffergator)" },
  },
	init = function()
		vim.g.buffergator_split_size = "10"
		vim.g.buffergator_display_regime = "bufname"
    vim.g.buffergator_autoexpand_on_split = 1
    vim.g.buffergator_show_full_directory_path = 0
    vim.g.buffergator_viewport_split_policy = 'n' -- use current window
    vim.g.buffergator_autodismiss_on_select = 1 -- close after picking
	end,
}
