-- Adapted version of dark theme -> light theme with valid Lua hex colors

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "kindlight_light"

local hl = vim.api.nvim_set_hl

-- Core UI
hl(0, "Normal",       { fg = "#202124", bg = "#fcf6e5" })
hl(0, "NonText",      { fg = "#aaaaaa" })
hl(0, "LineNr",       { fg = "#aaaaaa", bg = "#fcf6e5" })
hl(0, "CursorLine",   { bg = "#f5f0dc" })
hl(0, "Visual",       { bg = "#e7dec4" })

-- Statusline
hl(0, "StatusLine",   { fg = "#333333", bg = "#dddddd", bold = true })
hl(0, "StatusLineNC", { fg = "#888888", bg = "#eeeeee" })
hl(0, "VertSplit",    { fg = "#cccccc", bg = "#fcf6e5" })
hl(0, "TabLine",      { fg = "#777777", bg = "#f0f0f0" })
hl(0, "TabLineSel",   { fg = "#000000", bg = "#dddddd", bold = true })

-- Syntax
hl(0, "Comment",      { fg = "#6b6b6b", italic = true })
hl(0, "Constant",     { fg = "#c71585" })
hl(0, "String",       { fg = "#228b22" })
hl(0, "Identifier",   { fg = "#1e3a5f" })
hl(0, "Function",     { fg = "#0077aa", bold = true })
hl(0, "Keyword",      { fg = "#b22222", italic = true })
hl(0, "Statement",    { fg = "#b22222", italic = true })
hl(0, "Type",         { fg = "#d2691e", italic = true })
hl(0, "PreProc",      { fg = "#0077aa" })
hl(0, "Special",      { fg = "#8b008b" })
hl(0, "Todo",         { fg = "#ffffff", bg = "#e69a00", bold = true })

-- Search
hl(0, "Search",       { fg = "#000000", bg = "#ffdf91", bold = true })
hl(0, "IncSearch",    { fg = "#000000", bg = "#f5c542" })

-- Diff
hl(0, "DiffAdd",      { bg = "#d2f8d2" })
hl(0, "DiffChange",   { bg = "#f8f8d2" })
hl(0, "DiffDelete",   { fg = "#aa2222", bg = "#ffdddd" })
hl(0, "DiffText",     { bg = "#cce5ff", bold = true })

-- Completion
hl(0, "Pmenu",        { fg = "#202124", bg = "#eeeeee" })
hl(0, "PmenuSel",     { fg = "#202124", bg = "#cccccc" })

-- Match Parens
hl(0, "MatchParen",   { fg = "#000000", bg = "#ffe58a", bold = true })

-- Treesitter
hl(0, "@keyword",         { link = "Keyword" })
hl(0, "@function",        { link = "Function" })
hl(0, "@variable",        { fg = "#2c3e50" })
hl(0, "@string",          { link = "String" })
hl(0, "@type",            { link = "Type" })
hl(0, "@constant",        { fg = "#c71585" })
hl(0, "@comment",         { link = "Comment" })
hl(0, "@number",          { fg = "#cd853f" })
hl(0, "@function.call",   { fg = "#0077aa" })
hl(0, "@parameter",       { fg = "#4d4d4d", italic = true })
