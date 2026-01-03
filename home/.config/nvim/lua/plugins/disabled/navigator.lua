return {
	"ray-x/navigator.lua",
	event = "LspAttach", -- spin up *after* the first server
	enabled = false,
	dependencies = {
		{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
	},
	opts = {
		default_mapping = false, -- keep your own <K>/<gd> etc.
		lsp = { -- navigator won’t touch server setup
			disable_lsp = {}, -- add names here if you run duplicates
		},
	},
}
