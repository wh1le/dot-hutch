return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" }, -- VS-Code pack
  build = "make install_jsregexp",
  config = function ()
    local ls = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    require("luasnip.loaders.from_lua").lazy_load({
      paths = { "~/.config/nvim/lua/snippets" },
    })

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })
  end
}
