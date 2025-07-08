return {
   "pgdouyon/vim-yin-yang",
   priority = 1000,
   config = function ()
      require("e-ink").setup()
      vim.cmd.colorscheme "e-ink"
      -- choose light mode or dark mode
      vim.opt.background = "light"
   end
}
