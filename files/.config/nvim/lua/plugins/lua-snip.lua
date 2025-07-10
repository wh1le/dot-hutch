return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "folke/which-key.nvim",
  },
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
    local map = vim.keymap.set
    local opts = { silent = true, expr = true }

    -- Jump forward
    map({ "i", "s" }, "<Tab>", function()
      return ls.jumpable(1) and ls.jump(1) or "<Tab>"
    end, opts)

    -- Jump backward
    map({ "i", "s" }, "<S-Tab>", function()
      return ls.jumpable(-1) and ls.jump(-1) or "<S-Tab>"
    end, opts)

    -- Optional: Change choice (for choice nodes)
    map({ "i", "s" }, "<C-n>", function()
      if ls.choice_active() then ls.change_choice(1) end
    end, { silent = true })

    map({ "i", "s" }, "<C-p>", function()
      if ls.choice_active() then ls.change_choice(-1) end
    end, { silent = true })

    require("which-key").register({
      {
        mode = { "i" },
        { "<C-n>", desc = "LuaSnip next choice" },
        { "<C-p>", desc = "LuaSnip prev choice" },
        { "<S-Tab>", desc = "LuaSnip jump backward" },
        { "<Tab>", desc = "LuaSnip jump forward" },
      },
    })
end
}
