local uname = vim.loop.os_uname().sysname

local function on_path(bin) return vim.fn.executable(bin) == 1 end

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
  elseif on_path("wl-copy") and on_path("wl-paste") then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = {["+"]={"wl-copy","--foreground","--type","text/plain"}, ["*"]={"wl-copy","--foreground","--primary","--type","text/plain"}},
      paste = {["+"]={"wl-paste","--no-newline"},                    ["*"]={"wl-paste","--no-newline","--primary"}},
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
