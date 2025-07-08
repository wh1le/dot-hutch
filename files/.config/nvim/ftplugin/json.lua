vim.g.vim_json_syntax_conceal = 0

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".eslintrc",
  callback = function()
    vim.bo.filetype = "json"
  end,
})
