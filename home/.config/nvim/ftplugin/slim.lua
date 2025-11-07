vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.slim",
  callback = function()
    vim.bo.filetype = "slim"
  end,
})
