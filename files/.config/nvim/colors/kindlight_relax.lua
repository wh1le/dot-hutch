-- Kindlight Relaxed – a gentle light‑background scheme with muted, low‑contrast accents
-- Focus: reduce eye strain by toning down vivid hues, leaving the warm paper‑like background intact.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "kindlight_relaxed"

local hl = vim.api.nvim_set_hl

-- Palette -----------------------------------------------------------
local p = {
  bg         = "#e1e3ec", -- unchanged warm background
  fg         = "#202124", -- primary text (very dark grey)
  dim_text   = "#4d4d4d", -- subdued text / parameters
  line_nr    = "#878787", -- line numbers
  cursor_bg  = "#202124", -- dark cursor block
  cursor_fg  = "#fcf6e5", -- text colour inside the cursor
  cursorline = "#ece5cf", -- subtle current‑line highlight
  visual_bg  = "#dfd6bc", -- visual selection
  status_fg  = "#333333",
  status_bg  = "#dddddd",

  -- syntax accents (muted, ~30–40 % darker than originals)
  comment    = "#555555",
  constant   = "#8b1b5e",
  string     = "#1e5621",
  identifier = "#153455",
  func       = "#004766",
  keyword    = "#7f2121",
  type       = "#8b4f14",
  number     = "#7a5c1c",
  number_bg  = "#8499f0",
  preproc    = "#004766",
  special    = "#5d2c5d",
  todo_bg    = "#c48a00",

  search_fg  = "#000000",
  search_fg  = "#FFAB00",
  search_bg  = "#f5c542",

  search_fg  = "#FFAB00",
  search_bg  = "#f5c542",
}

-- Core UI -----------------------------------------------------------
hl(0, "Normal",       { fg = p.fg, bg = p.bg })
hl(0, "NonText",      { fg = p.line_nr })
hl(0, "LineNr",       { fg = p.line_nr, bg = p.bg })
hl(0, "CursorLine",   { bg = p.cursorline })
hl(0, "CursorLineNr", { fg = p.fg, bg = p.cursorline, bold = true })
hl(0, "Visual",       { bg = p.visual_bg })
-- Cursor (block)
hl(0, "Cursor",       { fg = p.cursor_fg, bg = p.cursor_bg })
hl(0, "CursorIM",     { fg = p.cursor_fg, bg = p.cursor_bg })

-- Statusline & Tabs -------------------------------------------------
hl(0, "StatusLine",   { fg = p.status_fg, bg = p.status_bg, bold = true })
hl(0, "StatusLineNC", { fg = "#888888",  bg = "#eeeeee" })
hl(0, "VertSplit",    { fg = "#cccccc",  bg = p.bg })
hl(0, "TabLine",      { fg = "#777777",  bg = "#f0f0f0" })
hl(0, "TabLineSel",   { fg = p.fg,       bg = p.status_bg, bold = true })

-- Syntax ------------------------------------------------------------
hl(0, "Comment",      { fg = p.comment, italic = true })
hl(0, "Constant",     { fg = p.constant })
hl(0, "String",       { fg = p.string })
hl(0, "Identifier",   { fg = p.identifier })
hl(0, "Function",     { fg = p.func, bold = true })
hl(0, "Keyword",      { fg = p.keyword, italic = true })
hl(0, "Statement",    { fg = p.keyword, italic = true })
hl(0, "Type",         { fg = p.type, italic = true })
hl(0, "PreProc",      { fg = p.preproc })
hl(0, "Special",      { fg = p.special })
hl(0, "Todo",         { fg = "#ffffff", bg = p.todo_bg, bold = true })

-- Search & Match ----------------------------------------------------
hl(0, "Search",       { fg = p.search_fg, bg = p.search_bg, bold = true })
hl(0, "IncSearch",    { fg = p.search_fg, bg = p.search_bg })
hl(0, "MatchParen",   { bg = "#ffe58a", fg = p.fg, bold = true })

-- Diff --------------------------------------------------------------
hl(0, "DiffAdd",      { bg = "#d4f0d4" })
hl(0, "DiffChange",   { bg = "#f0f0d4" })
hl(0, "DiffDelete",   { fg = "#882222", bg = "#ffdede" })
hl(0, "DiffText",     { bg = "#c8e0ff", bold = true })

-- Completion --------------------------------------------------------
hl(0, "Pmenu",        { fg = p.fg, bg = "#eeeeee" })
hl(0, "PmenuSel",     { fg = p.fg, bg = "#cccccc" })

-- Treesitter links --------------------------------------------------
hl(0, "@comment",         { link = "Comment" })
hl(0, "@constant",        { link = "Constant" })
hl(0, "@string",          { link = "String" })
hl(0, "@keyword",         { link = "Keyword" })
hl(0, "@function",        { link = "Function" })
hl(0, "@function.call",   { fg = p.func })
hl(0, "@variable",        { fg = p.identifier })
hl(0, "@parameter",       { fg = p.dim_text, italic = true })
hl(0, "@type",            { link = "Type" })
--
-- later in the Syntax section
hl(0, "Number",   { fg = p.number, bg = p.number_bg })
hl(0, "@number",  { fg = p.number })
