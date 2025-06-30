-- Custom line number styling
vim.cmd [[
  hi LineNr       term=bold ctermfg=Blue guifg=Blue
  hi LineNrBelow  term=italic ctermfg=Gray guifg=Gray
  hi LineNrAbove  term=italic ctermfg=Gray guifg=Gray
]]

-- Highlight function names (based on: https://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim/773392#773392)
vim.cmd [[
  syn match   cCustomParen    "(" contains=cParen contains=cCppParen
  syn match   cCustomFunc     "\w\+\s*(" contains=cCustomParen

  hi def link cCustomFunc Function
  hi Function term=italic gui=italic
]]

-- Clear existing highlights and reset syntax
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "kindlight"

local hl = vim.api.nvim_set_hl

-- Core UI
hl(0, "Normal",       { fg = "#c8cbe0", bg = "#1b1d2b" })
hl(0, "NonText",      { fg = "#5c5f77", bg = "#1b1d2b" })
hl(0, "LineNr",       { fg = "#5c5f77", bg = "#1b1d2b" })
hl(0, "CursorLine",   { bg = "#232436" })
hl(0, "Visual",       { bg = "#2c2c3a" })

-- Statusline / UI
hl(0, "StatusLine",   { fg = "#a6accd", bg = "#1b1d2b", bold = true })
hl(0, "StatusLineNC", { fg = "#5c5f77", bg = "#1b1d2b" })
hl(0, "VertSplit",    { fg = "#2c2e3a", bg = "#1b1d2b" })
hl(0, "TabLine",      { fg = "#5c5f77", bg = "#1b1d2b" })
hl(0, "TabLineSel",   { fg = "#cdd6f4", bg = "#1b1d2b", bold = true })

-- Syntax
hl(0, "Comment",      { fg = "#55596f", italic = true }) -- softer gray
hl(0, "Constant",     { fg = "#6c7086" }) -- includes None/True
hl(0, "String",       { fg = "#a6e3a1" })
hl(0, "Identifier",   { fg = "#aab2cf" }) -- softer than white
hl(0, "Function",     { fg = "#b4befe", bold = true })
hl(0, "Keyword",      { fg = "#89b4fa" })
hl(0, "Statement",    { fg = "#89b4fa" })
hl(0, "Type",         { fg = "#fab387" })
hl(0, "PreProc",      { fg = "#89b4fa" })
hl(0, "Special",      { fg = "#f2cdcd" })
hl(0, "Todo",         { fg = "#1e1e2e", bg = "#f9e2af", bold = true })

-- Python-specific
hl(0, "pythonBuiltin",  { fg = "#6c7086" }) -- same muted as constants
hl(0, "pythonFunction", { fg = "#b4befe", bold = true })
hl(0, "pythonRepeat",   { fg = "#f38ba8", bold = true })
hl(0, "pythonInclude",  { fg = "#89b4fa" })

-- Diff
hl(0, "DiffAdd",      { bg = "#2e3a2e" })
hl(0, "DiffChange",   { bg = "#2e2e3a" })
hl(0, "DiffDelete",   { fg = "#4b1e1e", bg = "#2e2e2e" })
hl(0, "DiffText",     { bg = "#334155", bold = true })

-- Search
hl(0, "Search",       { fg = "#cdd6f4", bg = "#2c3b4a", bold = true })
hl(0, "IncSearch",    { fg = "#ffffff", bg = "#3a4b5c" })

-- Completion popup
hl(0, "Pmenu",        { fg = "#cdd6f4", bg = "#2b2b3a" })
hl(0, "PmenuSel",     { fg = "#a6accd", bg = "#3e3e4e" })

-- Parens
hl(0, "MatchParen",   { fg = "#f9e2af", bg = "#3a3a4a", bold = true })

-- Treesitter
hl(0, "@keyword",              { link = "Keyword" })
hl(0, "@keyword.function",     { link = "Keyword" })
hl(0, "@keyword.return",       { link = "Keyword" })
hl(0, "@type",                 { link = "Type" })
hl(0, "@type.builtin",         { link = "Type" })
hl(0, "@function",             { link = "Function" })
hl(0, "@function.builtin",     { link = "Function" })
hl(0, "@string",               { link = "String" })
hl(0, "@comment",              { link = "Comment" })
hl(0, "@number",               { link = "Constant" })

-- Muted special constants like None/True
hl(0, "@constant",             { fg = "#6c7086" })
hl(0, "@constant.builtin",     { fg = "#6c7086" })
hl(0, "@variable.builtin",     { fg = "#6c7086" })

-- Softer variables (like l1_value)
hl(0, "@variable",             { fg = "#aab2cf" })
hl(0, "@variable.member",      { fg = "#aab2cf" })
hl(0, "Identifier",            { fg = "#aab2cf" })

-- NerdTree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nerdtree",
  callback = function()
    hl(0, "Normal",              { bg = "#1b1d2b", fg = "#5c5f77" })
    hl(0, "Directory",           { fg = "#cba6f7" })
    hl(0, "NERDTreeDirSlash",    { fg = "#cba6f7" })
    hl(0, "NERDTreeOpenable",    { fg = "#cba6f7" })
    hl(0, "NERDTreeClosable",    { fg = "#cba6f7" })
  end,
})

vim.cmd [[
  hi! clear @variable
  hi! clear @variable.member
  hi! clear Identifier
]]

hl(0, "@variable",             { fg = "#959cb5" })
hl(0, "@variable.member",      { fg = "#959cb5" })
hl(0, "Identifier",            { fg = "#959cb5" })

-- Variables (used a lot — should be low-contrast but readable)
hl(0, "@variable",         { fg = "#858ba0" })       -- slightly darker than current
hl(0, "@variable.member",  { fg = "#858ba0" })
hl(0, "Identifier",        { fg = "#858ba0" })

-- Operators and punctuation (softened so logic flows don't pop too much)
hl(0, "@operator",         { fg = "#5c5f77" })
hl(0, "@punctuation",      { fg = "#5c5f77" })

-- Numbers (a touch more noticeable, for indexing, ranges, etc.)
hl(0, "@number",           { fg = "#f9e2af" })  -- keep consistent with constants

-- Function calls (add warmth for readability)
hl(0, "@function.call",    { fg = "#cba6f7" })
hl(0, "@number", { fg = "#6c7086" })
hl(0, "@constructor", { fg = "#959cb5" })        -- muted blue
hl(0, "@function.call", { fg = "#959cb5" })      -- match variables
-- Soften function *calls* like addTwoNumbers()
-- Function definitions: bold highlight
hl(0, "@function", { fg = "#b4befe", bold = true })

-- Function calls: subtle + non-bold
hl(0, "@function.call", { fg = "#959cb5" })
-- Definitions: still bold
hl(0, "Function", { fg = "#b4befe", bold = true })

-- Soften function *calls* via identifier fallback
hl(0, "@function",         { fg = "#959cb5" })
hl(0, "@function.builtin", { fg = "#959cb5" })

-- Fallback: generic identifier soft for calls (but will apply globally!)
hl(0, "Identifier",        { fg = "#959cb5" })


hl(0, "@attribute", { fg = "#959cb5", italic = true })
hl(0, "@variable.builtin", { fg = "#6c7086", italic = true }) -- already muted, now softened
hl(0, "@parameter", { fg = "#959cb5", italic = true })
hl(0, "@function.method", { fg = "#959cb5", italic = true })
hl(0, "Type", { fg = "#fab387", italic = true }) -- light orange + italic
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { link = "Type" })
hl(0, "Keyword", { fg = "#89b4fa", italic = true })
hl(0, "Statement", { fg = "#89b4fa", italic = true })
hl(0, "@keyword", { link = "Keyword" })
hl(0, "@keyword.function", { link = "Keyword" })
hl(0, "@keyword.return", { link = "Keyword" })
hl(0, "@constant.builtin", { fg = "#6c7086", italic = true })
hl(0, "@parameter", { fg = "#aab2cf", italic = true }) -- soft blue + italic
hl(0, "@attribute", { fg = "#f9e2af", italic = true }) -- soft yellow

-- Keywords like `if`, `else`, `while`, `return`
hl(0, "Keyword", { fg = "#89b4fa", italic = true })
hl(0, "Statement", { fg = "#89b4fa", italic = true })
hl(0, "@keyword", { link = "Keyword" })
hl(0, "@keyword.function", { link = "Keyword" })
hl(0, "@keyword.return", { link = "Keyword" })

-- Types like `ListNode`, `int`
hl(0, "Type", { fg = "#fab387", italic = true })
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { link = "Type" })

-- Constants like `None`, `True`, `False`
hl(0, "Constant", { fg = "#6c7086", italic = true })
hl(0, "@constant.builtin", { fg = "#6c7086", italic = true })
hl(0, "@constant", { fg = "#6c7086", italic = true })

-- Parameters like `self`, `val`
hl(0, "@parameter", { fg = "#aab2cf", italic = true })

-- Optional: decorators/annotations if used
hl(0, "@attribute", { fg = "#f9e2af", italic = true })



-- Keywords (flow control): soft blue, italic
hl(0, "Keyword", { fg = "#89b4fa", italic = true })
hl(0, "Statement", { fg = "#89b4fa", italic = true })

-- Types: warm orange, italic
hl(0, "Type", { fg = "#fab387", italic = true })
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { link = "Type" })

-- Constants like None, True: muted, italic
hl(0, "Constant", { fg = "#6c7086", italic = true })
hl(0, "@constant.builtin", { fg = "#6c7086", italic = true })
hl(0, "@constant", { fg = "#6c7086", italic = true })

-- Parameters like self, val: italic + slightly dimmed
hl(0, "@parameter", { fg = "#a0a4c0", italic = true })

-- Function definitions: bold to anchor your eye
hl(0, "@function", { fg = "#b4befe", bold = true })

-- Function calls (like `addTwoNumbers()`): NOT bold, calm color
hl(0, "@function.call", { fg = "#959cb5", italic = false })

-- Decorators / annotations (e.g., @staticmethod): yellow and italic
hl(0, "@attribute", { fg = "#f9e2af", italic = true })

-- Comments: still italic and soft
hl(0, "Comment", { fg = "#55596f", italic = true })
hl(0, "String", { fg = "#8c8fa1" })         -- muted gray-blue
hl(0, "@string", { link = "String" })
-- Chill types
hl(0, "Type", { fg = "#999db3" })                -- softer, bluish-gray
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { fg = "#7f849c" })       -- more muted than normal
