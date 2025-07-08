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
    vim.cmd('hi StatusLine guibg=black guifg=white')
  elseif m == 'i' then
    vim.cmd('hi StatusLine guibg=black guifg=white')
  elseif m == 'v' then
    vim.cmd('hi StatusLine guibg=black guifg=white')
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

function _G.MyStatus()
  local ft = vim.bo.filetype
  if ft == "NvimTree" or ft == "aerial" then
    return ""        -- show nothing in those panes
  end

  -- ⬇️ everything you had before, verbatim ⬇️
  return table.concat({
    _G.StatuslineMode(),
    _G.ReadOnly(),
    _G.PasteForStatusline(),
    " " .. vim.bo.filetype,
    " " .. _G.GitBranch(),
    " " .. _G.TruncFile(),
    "%m",
    "%=",
    _G.CocStatus(),
    " %l:%c",
    " %p%% ",
  }, "")
end

-- vim.o.statusline = table.concat({
--   "%#StatusLine#",
--   "%{%v:lua.StatuslineMode()%}",
--   "%{%v:lua.ReadOnly()%}",
--   "%{%v:lua.PasteForStatusline()%}",
--   " %y",
--   " %{v:lua.GitBranch()}",
--   "%{v:lua.TruncFile()}",
--   "%m",
--   "%=",
--   "%{v:lua.CocStatus()}",
--   " %l:%c",
--   " %p%% ",
-- },
-- "")

vim.o.statusline = "%{%v:lua.MyStatus()%}"

vim.o.laststatus = 2

-- after the statusline definition:
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = { "NvimTree", "aerial" },
  callback = function()
    -- run *after* the plugins set their own statusline
    vim.opt_local.statusline = ""
    vim.opt_local.winbar     = ""
  end,
})

local function black_bar_white_text()
  vim.cmd([[
    hi! StatusLine   guibg=#000000 guifg=#FFFFFF gui=NONE ctermfg=15 ctermbg=0
    hi! StatusLineNC guibg=#000000 guifg=#FFFFFF gui=NONE ctermfg=15 ctermbg=0
  ]])
end

black_bar_white_text()  -- run now
vim.api.nvim_create_autocmd("ColorScheme", { callback = black_bar_white_text })

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'NvimTree', 'aerial' },
--   callback = function()
--     vim.opt_local.statusline = ''   -- hide
--     vim.opt_local.winbar     = ''   -- hide if you use winbar
--   end,
-- })

