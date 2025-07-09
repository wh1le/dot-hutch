return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✔",
          package_pending = "➜",
          package_uninstalled = "✘"
        }
      }
    })
  end
}
