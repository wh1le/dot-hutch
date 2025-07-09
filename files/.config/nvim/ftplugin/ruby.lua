vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.wo.number = true
    vim.bo.expandtab = true
    vim.bo.tabstop = 2

    -- local hl = vim.api.nvim_set_hl
    -- hl(0, "@keyword",           { fg = "#89b4fa", italic = true })
    -- hl(0, "@function.call",     { fg = "#b0b4d4" })
    -- hl(0, "@function.builtin",  { fg = "#a6accd", italic = true })
    -- hl(0, "@type",              { fg = "#fab387", italic = true })
    -- hl(0, "@variable",          { fg = "#959cb5", italic = true })
    -- hl(0, "@variable.member",   { fg = "#959cb5", underline = true })
    -- local hl = vim.api.nvim_set_hl
    --
    -- -- Dim keywords + italic
    -- hl(0, "@keyword", { fg = "#7a88aa", italic = true })
    --
    -- -- Soften method calls (e.g., `Cat.new`)
    -- hl(0, "@function.call", { fg = "#7c84a6" })
    --
    -- -- Strings: gentle green instead of bright
    -- hl(0, "@string", { fg = "#96c199" })
    --
    -- -- Class/type names (e.g., `Cat`)
    -- hl(0, "@type", { fg = "#cba6f7", italic = true })
    --
    -- -- Variables
    -- hl(0, "@variable", { fg = "#848ca4", italic = true })
    -- hl(0, "@variable.member", { fg = "#848ca4", underline = true })
    --
    -- -- Constants (e.g. `:happy`)
    -- hl(0, "@constant", { fg = "#9ca0b0", italic = true })
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { ".pryrc", "Guardfile" },
  callback = function()
    vim.bo.filetype = "ruby"
  end,
})
