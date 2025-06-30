vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.coffee",
  callback = function()
    vim.bo.filetype = "coffee"
  end,
})
