vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { ".pryrc", "Guardfile" },
  callback = function()
    vim.bo.filetype = "ruby"
  end,
})
