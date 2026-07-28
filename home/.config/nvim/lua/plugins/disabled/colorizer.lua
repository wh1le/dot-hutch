return {
	"NvChad/nvim-colorizer.lua",
	enabled = false,
	opts = {
		filetypes = { "lua", "css", "vim", "conf", "tmux" }, -- Filetype options.  Accepts table like `user_default_options`
		buftypes = {}, -- Buftype options.  Accepts table like `user_default_options`
		-- Boolean | List of usercommands to enable.  See User commands section.
		user_default_options = {
			virtualtext = "■",
		},
	},
}
