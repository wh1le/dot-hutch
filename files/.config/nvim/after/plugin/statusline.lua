-- ─── Statusline Helper Functions ─────────────────────────────

function _G.StatuslineMode()
  local m = vim.fn.mode()
  return (m == 'n' and '[N]')
      or (m == 'i' and '[I]')
      or (m == 'v' and '[V]')
      or (m == 'R' and '[R]')
      or (m == 'c' and '[C]')
      or ''
end

function _G.PasteForStatusline()
  return vim.o.paste and '🧷' or '👾'
end

function _G.ReadOnly()
  return vim.o.readonly or not vim.o.modifiable and '🔒' or ''
end

function _G.GitBranch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if not handle then return '' end
  local branch = handle:read("*a") or ''
  handle:close()
  branch = branch:gsub("\n", "")
  return branch ~= '' and ' ' .. branch or ''
end

function _G.CocStatus()
  local status = vim.g.coc_status or ''
  return status == '' and '💤' or status
end

function _G.EncodingDisplay()
  local enc = vim.o.fileencoding
  local ff = vim.o.fileformat
  return (enc ~= 'utf-8' or ff ~= 'unix') and string.format('[%s:%s]', enc, ff) or ''
end

function _G.TruncFile()
  local width = vim.fn.winwidth(0)
  return width > 80 and vim.fn.expand('%:~:.') or vim.fn.expand('%:t')
end

function _G.ModeHighlight()
  local m = vim.fn.mode()
  if m == 'n' then
    vim.cmd('hi StatusLine guibg=#1e1e2e guifg=#c5c8c6')
  elseif m == 'i' then
    vim.cmd('hi StatusLine guibg=#1e1e2e guifg=#a6e3a1')
  elseif m == 'v' then
    vim.cmd('hi StatusLine guibg=#1e1e2e guifg=#f5c2e7')
  end
end

-- ─── Autocommand for Mode-based Highlight ─────────────────────

vim.api.nvim_create_augroup("ModeColors", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeColors",
  pattern = "*",
  callback = _G.ModeHighlight,
})

-- ─── Statusline Setup ─────────────────────────────────────────

vim.o.statusline = table.concat({
  "%#StatusLine#",
  "%{%v:lua.StatuslineMode()%}",
  "%{%v:lua.ReadOnly()%}",
  "%{%v:lua.PasteForStatusline()%}",
  " %y",
  " %{v:lua.GitBranch()}",
  "%{v:lua.TruncFile()}",
  "%m",
  "%=",
  "%{v:lua.CocStatus()}",
  " %l:%c",
  " %p%% ",
}, "")
