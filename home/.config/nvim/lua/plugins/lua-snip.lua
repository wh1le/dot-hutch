return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- "folke/which-key.nvim",
		"honza/vim-snippets",
	},
	build = "make install_jsregexp",
	config = function()
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_snipmate").lazy_load()

		require("luasnip.loaders.from_lua").lazy_load({
			paths = { "~/.config/nvim/lua/snippets" },
		})

		luasnip.add_snippets("all", {
			luasnip.snippet("!", {
				luasnip.text_node({ "#!/usr/bin/env bash", "" }),
			}),
		})

		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})
	end,
}
