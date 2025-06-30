return {
  "windwp/nvim-autopairs",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require('nvim-autopairs.rule')
    local ts_conds = require("nvim-autopairs.ts-conds")

    npairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
    })
  end
}
