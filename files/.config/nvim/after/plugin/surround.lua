-- Default visual mapping for Si
vim.keymap.set('v', 'Si', "S(i_<Esc>f)", { noremap = true })

-- Mako-specific override for Si
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mako",
  callback = function()
    vim.keymap.set('v', 'Si', 'S"i${ _(<Esc>2f"a) }<Esc>', { noremap = true, buffer = true })
  end,
})
