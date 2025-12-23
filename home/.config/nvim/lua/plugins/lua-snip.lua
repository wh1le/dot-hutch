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

		for _, ft in ipairs({ "sh", "bash", "zsh" }) do
			luasnip.add_snippets(ft, {
				luasnip.snippet("!", { luasnip.text_node({ "#!/usr/bin/env bash", "" }) }),
				luasnip.snippet("dn", { luasnip.text_node("&>/dev/null") }),
			})
		end

		-- luasnip.add_snippets("sh", {
		-- 	luasnip.snippet("!", {
		-- 		luasnip.text_node({ "#!/usr/bin/env bash", "" }),
		-- 	}),
		-- 	luasnip.snippet("dn", {
		-- 		luasnip.text_node({ "&>/dev/null", "" }),
		-- 	}),
		-- })

		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})
	end,
}
