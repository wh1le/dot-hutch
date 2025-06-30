vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".eslintrc",
  callback = function()
    vim.bo.filetype = "json"
  end,
})
