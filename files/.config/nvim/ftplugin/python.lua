-- Global settings for indentLine (disable for some, enable for Python)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "markdown", "vimwiki" },
  callback = function()
    vim.g.indentLine_enabled = 0
  end,
})

-- Python-specific settings
vim.api.nvim_create_augroup("python_setup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  group = "python_setup",
  callback = function()
    -- PEP8 indentation
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.autoindent = true
    vim.bo.smartindent = true

    -- Recommended style overrides
    vim.g.python_recommended_style = 0

    -- Enable indentLine
    vim.g.indentLine_enabled = 1
    vim.g.indentLine_char = "▏"
  end,
})
