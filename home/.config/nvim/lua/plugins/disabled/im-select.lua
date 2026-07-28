return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = function()
    local is_wsl = vim.fn.has("wsl") == 1
    local linux_cmd = vim.fn.executable("fcitx5-remote") == 1 and "fcitx5-remote" or "ibus"
    require("im_select").setup({
      default_command   = is_wsl and "im-select.exe" or linux_cmd,
      default_im_select = is_wsl and "1033" or (linux_cmd == "fcitx5-remote" and "keyboard-us" or "xkb:us::eng"),
      set_default_events  = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter", "CmdlineEnter" },
    })
  end,
}
