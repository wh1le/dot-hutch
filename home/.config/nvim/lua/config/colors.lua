-- https://en.wikipedia.org/wiki/X11_color_names?utm_source=chatgpt.com
-- whitesmoke — #F5F5F5 (very pale)
-- ghostwhite — #F8F8FF (near-white, bluish)
-- gray95 (X11) — #F2F2F2
-- gray90 (X11) — #E6E6E6
-- gainsboro — #DCDCDC
-- lightgray — #D3D3D3 (CSS)
-- gray80 (X11) — #CCCCCC
-- silver — #C0C0C0
-- gray70 (X11) — #B2B2B2
-- darkgray — #A9A9A9 (darker, included for context)

local function hl(grp, spec)
	vim.api.nvim_set_hl(0, grp, spec)
end

-- For newbies: fg is text, bg is background color

vim.o.background = "light"
vim.o.termguicolors = true
-- vim.g.base16colorspace = 256
-- vim.cmd("syntax sync minlines=256")
-- vim.env.TERM = "tmux-256color" -- Needs to be removed, because it should be set either by wezterm or tmux
-- vim.cmd([[ hi htmlArg cterm=italic hi Type cterm=italic]])

-- vim.cmd("highlight Normal guibg=NONE")
hl("Normal", { bg = "White", ctermbg = "White" })

hl("StatusLine", { bg = "White", fg = "Black" })
hl("StatusLineNC", { bg = "White", fg = "Black" })
hl("WinSeparator", { fg = "Black" })
-- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#e5e5e5" })

-- popups
hl("FloatBorder", { fg = "#000000", bg = "#ffffff" })
hl("NormalFloat", { bg = "#ffffff" })

-- menu
hl("Pmenu", { bg = "#ffffff", fg = "#000000" }) -- popup bg white, text black
hl("PmenuSel", { bg = "#e0e0e0", fg = "#000000" }) -- selection: light gray bg
hl("PmenuSbar", { bg = "#d0d0d0" }) -- scrollbar bg
hl("PmenuThumb", { bg = "#000000" }) -- scrollbar thumb (black)

-- code
hl("Comment", { fg = "LightGrey" })
hl("@comment", { fg = "LightGrey" })
hl("@lsp.type.comment", { bold = false, fg = "LightGrey" })

-- core-ui
hl("CursorLine", { bg = "#f2f2f2" })
hl("Visual", { bg = "#d0d0d0" })
hl("LineNr", { fg = "Gainsboro", bold = true, italic = true })
hl("CursorLineNr", { bold = true })
hl("MatchParen", { bg = "Snow", fg = "Black", bold = true })

-- aerial
hl("AerialFunction", { bold = true })
hl("AerialMethod", { bold = true })
hl("AerialClass", { bold = true })
hl("AerialConstructor", { bold = true })

-- nvim-tree
hl("NvimTreeFolderName", { bold = true })
hl("NvimTreeOpenedFolderName", { bold = true })
hl("NvimTreeFolderIcon", { bold = true })

-- nvim-cmp
hl("CmpItemAbbr", { fg = "#000000" }) -- main text
hl("CmpItemKind", { fg = "#333333" }) -- kind (method, class etc)
hl("CmpItemMenu", { fg = "#666666" }) -- source (buffer, lsp)

-- ---------------- Search -----------------
-- -- search: all matches vs current match

hl("Search", { bg = "gainsboro", fg = "Black", nocombine = true })
hl("IncSearch", { bg = "gainsboro", fg = "Black", bold = true, nocombine = true })
hl("CurSearch", { bg = "gainsboro", fg = "Black", bold = true, nocombine = true }) -- current match
-- hl("Search", { guibg = "White", guifg = "Gray", nocombine = true }) -- all matches

-- hl("IncSearch", { bg = "#ffd166", fg = "#000000", bold = true, nocombine = true })
-- hl("CurSearch", { bg = "#ffb703", fg = "#000000", bold = true, nocombine = true }) -- current match
--
-- -- cursor: visible everywhere
-- hl("Cursor", { bg = "#000000", fg = "#ffffff", nocombine = true })
-- hl("TermCursor", { bg = "#000000", fg = "#ffffff", nocombine = true })
-- hl("TermCursorNC", { bg = "#000000", fg = "#ffffff" })
-- vim.o.guicursor = "n-v-c:block-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,o:hor50-Cursor"
--
-- -- avoid clashes
-- hl("CursorLine", { bg = "#f2f2f2" }) -- no reverse
-- hl("Visual", { bg = "#d0d0d0" }) -- no reverse
--
-- vim.o.hlsearch = true
-- vim.o.incsearch = true

-- syntax
local link = function(child, parent)
	vim.api.nvim_set_hl(0, child, { link = parent })
end
hl("Keyword", { bold = true })
link("@keyword", "Keyword")

hl("Function", { italic = false })
link("@function", "Function")
link("@method", "Function")

hl("Identifier", { italic = false })
link("@variable", "Identifier")
link("@field", "Identifier")
link("@property", "Identifier")

hl("Constant", { bold = true })
link("@constant", "Constant")
link("@boolean", "Constant")
-- link("@number", )
link("@type", "Constant")

hl("String", { fg = "DarkGray" })
link("@string", "String")

hl("Operator", { bold = true })
link("@operator", "Operator")

-- diagnostics
hl("DiagnosticError", { bold = true, underline = false })
hl("DiagnosticWarn", { bold = true })
hl("DiagnosticInfo", { italic = true })
hl("DiagnosticHint", { italic = true, underline = false })

-- lsp
hl("LspReferenceText", { reverse = true })
hl("LspReferenceRead", { reverse = true })
hl("LspReferenceWrite", { reverse = true, bold = true })

-- diff
hl("DiffAdd", { underline = true })
hl("DiffDelete", { strikethrough = true })
hl("DiffChange", { bold = true })
hl("DiffText", { reverse = true })

vim.api.nvim_set_hl(0, "ErrorMsg", { fg = "#000000", bg = "#FFFFFF", bold = true })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#000000", bg = "#FFF1A8" })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = "#000000" })
vim.api.nvim_set_hl(0, "MsgArea", { fg = "#000000", bg = "#FFFFFF" }) -- optional

-- highlight spaces
vim.api.nvim_set_hl(0, "WsOnly", { bg = "OldLace" })
vim.fn.matchadd("WsOnly", [[^\s\+$]], 10)

vim.api.nvim_set_hl(0, "AerialWinNormal", { fg = "Black", bg = "White" })
vim.api.nvim_set_hl(0, "AerialWinNormalNC", { fg = "Black", bg = "White" })
vim.api.nvim_set_hl(0, "AerialCursorLine", { fg = "Black", bg = "Gray" }) -- active line
vim.api.nvim_set_hl(0, "AerialSeparator", { fg = "Black", bg = "White" })

local set = vim.api.nvim_set_hl
set(0, "AerialWin", { fg = "Black", bg = "Gray" })
set(0, "AerialWinNC", { fg = "Black", bg = "Gray" })
set(0, "AerialNormal", { fg = "Black", bg = "Gray", link = "White" })

set(0, "AerialLine", { bg = "LightGray" })
set(0, "AerialLineNC", { bg = "LightGray" })

set(0, "AerialIcon", { fg = "Black", bg = "White" })
set(0, "AerialClassIcon", { link = "AerialIcon" })
set(0, "AerialFunctionIcon", { fg = "Black", bg = "White" })

-- Neotest

hl("NeotestAdapterName", { fg = "Black", bg = "White" })
hl("NeotestPassed", { fg = "Black" })
hl("NeotestFailed", { fg = "Black" })
hl("NeotestRunning", { fg = "Black" })
hl("NeotestSkipped", { fg = "Black" })
hl("NeotestUnknown", { fg = "Black" })
hl("NeotestFile", { fg = "Black" })
hl("NeotestDir", { fg = "Black" })
hl("NeotestNamespace", { fg = "Black" })
hl("NeotestTest", { fg = "Black" })
hl("NeotestFocused", { fg = "Black" })
hl("NeotestMarked", { fg = "Black" })
hl("NeotestIndent", { fg = "Black" })
hl("NeotestExpander", { fg = "Black" })
hl("NeotestBorder", { fg = "Black" })
hl("NeotestWinSelect", { fg = "Black" })

-- lsp diagnostics
hl("DiagnosticVirtualTextError", { fg = "LightGray" })
hl("DiagnosticVirtualTextWarn", { fg = "LightGray" })
hl("DiagnosticVirtualTextInfo", { fg = "LightGray" })
hl("DiagnosticVirtualTextHint", { fg = "LightGray" })

-- current line
hl("CursorLineNr", { bg = "OldLace" })
hl("CursorLine", { bg = "OldLace" })
hl("CursorColumn", { bg = "OldLace" })

hl("TabLine", { bg = "OldLace" })
hl("TabLineSel", { bg = "gray95", bold = true }) -- active
hl("TabLineFill", { bg = "OldLace" })

vim.cmd("highlight link DiagnosticUnnecessary Normal")
vim.cmd("highlight link LspDiagnosticsDefaultUnnecessary Normal")

hl("DiagnosticSignError", { fg = "gray95" })
hl("DiagnosticSignWarn", { fg = "gray95" })
hl("DiagnosticSignInfo", { fg = "gray95" })
hl("DiagnosticSignHint", { fg = "gray95" })
