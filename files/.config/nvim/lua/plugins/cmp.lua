-- plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      -- … your cmp setup …
    })

    -- 📴   stop completion inside Navigator floating windows
    vim.api.nvim_create_autocmd("FileType", {
      pattern  = { "guihua", "guihua_rust" },
      callback = function() require("cmp").setup.buffer({ enabled = false }) end,
    })
  end,
}
