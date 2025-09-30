return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
	config = function()
		require("lspsaga").setup({
			use_cmp = true,
			code_action = {
				enable = false,
			},
			rename = {
				in_select = true, -- text pre-selected in prompt
				auto_save = true, -- write buffers after rename
				keys = {
					exec = "<CR>",
				},
			},
			lightbulb = {
				enable = false, -- master switch
				sign = false, -- no sign-column icon
				virtual_text = false, -- no “💡” at line end
			},
			symbol_in_winbar = {
				enable = false,
				show_file = true,
				color_mode = false,
				delay = 300,
			},
			diagnostic = {
				show_code_action = false,
			},
			code_action_prompt = {
				enable = false,
			},
		})
	end,
}
