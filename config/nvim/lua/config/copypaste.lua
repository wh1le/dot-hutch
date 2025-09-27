local uname = vim.loop.os_uname().sysname

if uname == "Linux" then
  if os.getenv("WSL_DISTRO_NAME") ~= nil then
    vim.g.clipboard = {
      name = "win32yank-wsl",
      copy = {
        ["+"] = { "win32yank.exe", "-i", "--crlf" },
        ["*"] = { "win32yank.exe", "-i", "--crlf" },
      },
      paste = {
        ["+"] = { "win32yank.exe", "-o", "--lf" },
        ["*"] = { "win32yank.exe", "-o", "--lf" },
      },
      cache_enabled = true,
    }
  else
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = { "xclip", "-selection", "clipboard" },
        ["*"] = { "xclip", "-selection", "primary" },
      },
      paste = {
        ["+"] = { "xclip", "-selection", "clipboard", "-o" },
        ["*"] = { "xclip", "-selection", "primary", "-o" },
      },
      cache_enabled = true,
    }
  end
elseif uname == "Darwin" then
  vim.opt.clipboard = "unnamedplus"
end
