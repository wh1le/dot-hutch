return {
	{
		"tpope/vim-rails",
		lazy = false,
	},
	{
		"vim-ruby/vim-ruby",
		ft = { "ruby", "eruby", "rake" },
		config = function()
			vim.g.ruby_indent_access_modifier_style = "normal"
			vim.g.ruby_indent_block_style = "do"
			vim.g.ruby_indent_hanging_elements = 1
			-- vim.g.ruby_no_expensive = 1
		end,
	},
}
