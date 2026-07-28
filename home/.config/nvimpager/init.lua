nvimpager.default_theme = false
nvimpager.maps = false
vim.opt.termguicolors = false
vim.cmd("highlight Normal ctermbg=NONE ctermfg=NONE")

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      require("nvimpager.ansi2highlight").run()
    end)
  end,
})
