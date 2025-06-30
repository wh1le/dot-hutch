vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*_spec.rb",
  callback = function()
    vim.bo.filetype = "ruby.spec"
  end,
})
