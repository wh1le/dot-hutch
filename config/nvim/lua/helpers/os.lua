NM.os = {
  is_wsl = function() 
    return vim.fn.has("wsl") == 1
  end,

  are_we_under_nixos = function()
    if (vim.uv or vim.loop).fs_stat("/etc/NIXOS") then
      return true
    else
      return false
    end
  end,

  open_cmd_provider = function()
    if vim.fn.has("mac") == 1 then
       return "open"
    elseif vim.fn.executable("wslview") == 1 then
      return "wslview"
    elseif vim.fn.executable("xdg-open") == 1 then
      return "xdg-open"
    else
      vim.notify("No system opener found for gx", vim.log.levels.ERROR)
    end
  end,


  open_file = function(path)
    vim.fn.jobstart({ NM.os.open_cmd_provider, path }, { detach = true })
  end
}
