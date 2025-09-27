NM.lazy = {
  setup = function()
    NM.lazy.verify_plugin_and_load()

    require("lazy").setup({
      spec = {
        { import = "plugins" },
        { import = "plugins.cmp" },
        { import = "plugins.lsp" },
        { import = "plugins.mason" },
        { import = "plugins.treesitter" },
      },
      install = { colorscheme = { "habamax" } },
      change_detection = {
        enabled = true,
        notify = false,
      },
      checker = { enabled = false },
    })
  end,

  verify_plugin_and_load = function()
    -- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    local lazypath = vim.fn.expand("~/.config/dot-files/dependencies/lazy.nvim")

    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      NM.lazy._clone(lazypath) 
    end

    vim.opt.rtp:prepend(lazypath)
  end,

  _clone = function(lazypath)
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
}
