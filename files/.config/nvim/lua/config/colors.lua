-- vim.cmd("highlight clear")
-- vim.api.nvim_set_hl(0, "Normal", { fg = "#000000", bg = "NONE" })
--
-- local function set_sl_palette()
-- 	local fg, bg = "#FFFFFF", "#000000"
--
-- 	-- core groups
-- 	vim.cmd(("hi! StatusLine   guifg=%s guibg=%s gui=NONE"):format(fg, bg))
-- 	vim.cmd(("hi! StatusLineNC guifg=%s guibg=%s gui=NONE"):format(fg, bg))
--
-- 	-- nvim-tree overrides its own groups → relink
-- 	vim.cmd([[
--     hi! link NvimTreeStatusLine    StatusLine
--     hi! link NvimTreeStatusLineNC  StatusLineNC
--   ]])
--
-- 	-- aerial uses normal StatusLine; nothing extra
-- end
--
-- set_sl_palette() -- run once at startup
--
local hl = vim.api.nvim_set_hl

hl(0, "Comment", { italic = true, fg = "lightGray" })
hl(0, "@comment", { italic = true, fg = "lightGray" })
hl(0, "@lsp.type.comment", { italic = true, fg = "lightGray" })
--
-- -- Check highlight group TSHighlightCapturesUnderCursor
-- -- print(vim.treesitter.highlighter.active[0] and "TS ON" or "TS OFF")
--
-- -- import / export
-- hl(0, "@include", { italic = true })
-- hl(0, "@keyword.import", { italic = true, link = "@include" })
-- hl(0, "@import.module", { bold = true })
--
-- hl(0, "@keyword", { bold = false })
-- hl(0, "@function", { bold = true })
-- -- hl(0, "@lsp.type.class", { bold = true })
-- -- hl(0, "@type.definition", { bold = true })
--
-- -- hl(0, "@function", { bold = true })
-- -- hl(0, "@function.call",     { fg = "#000000" })
-- -- hl(0, "@function.builtin",  { fg = "#000000", italic = true })
--
-- -- hl(0, "@keyword",           { fg = "#000000", italic = true })
-- -- hl(0, "@variable",          { fg = "#000000", italic = true })
-- -- hl(0, "@variable.member",   { fg = "#000000", underline = true })
-- -- hl(0, "@constant", { fg = "#000000", italic = true })
--
-- -- hl(0, "@method", { bold = true })
-- -- hl(0, "@lsp.type.function", { link = "Function", bold = true })
-- -- hl(0, "@lsp.type.method", { link = "Function", bold = true })
--
-- ✨ FOR TREESITTER (functions & methods)
-- hl(0, "@function", { bold = true })
-- hl(0, "@method", { bold = true })
-- hl(0, "@lsp.type.function", { bold = true })
-- hl(0, "@lsp.type.method", { bold = true })

-- 🏫 CLASSES / TYPES
-- hl(0, "@type", { bold = true })
-- hl(0, "@class", { bold = true })
-- hl(0, "@lsp.type.class", { bold = true })

-- 🧪 CONSTRUCTORS
-- hl(0, "@constructor", { bold = true })
-- hl(0, "@lsp.type.constructor", { bold = true })

-- 🧬 STRUCTS / ENUMS / INTERFACES
-- hl(0, "@struct", { bold = true })
-- hl(0, "@enum", { bold = true })
-- hl(0, "@interface", { bold = true })

-- UI --
-- ✨ FOR AERIAL (if using)
hl(0, "AerialFunction", { bold = true })
hl(0, "AerialMethod", { bold = true })
hl(0, "AerialClass", { bold = true })
hl(0, "AerialConstructor", { bold = true })

-- 📁 NVIM-TREE
hl(0, "NvimTreeFolderName", { bold = true })
hl(0, "NvimTreeOpenedFolderName", { bold = true })
hl(0, "NvimTreeFolderIcon", { bold = true })

hl(0, "Pmenu", { bg = "#ffffff", fg = "#000000" }) -- popup bg white, text black
hl(0, "PmenuSel", { bg = "#e0e0e0", fg = "#000000" }) -- selection: light gray bg
hl(0, "PmenuSbar", { bg = "#d0d0d0" }) -- scrollbar bg
hl(0, "PmenuThumb", { bg = "#000000" }) -- scrollbar thumb (black)
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#333333", fg = "#ffffff", bold = true })

-- Optional: for nvim-cmp item kinds
hl(0, "CmpItemAbbr", { fg = "#000000" }) -- main text
hl(0, "CmpItemKind", { fg = "#333333" }) -- kind (method, class etc)
hl(0, "CmpItemMenu", { fg = "#666666" }) -- source (buffer, lsp)

-- Popup border (used by cmp, lsp, etc)
hl(0, "FloatBorder", { fg = "#000000", bg = "#ffffff" }) -- thin black border
hl(0, "NormalFloat", { bg = "#ffffff" }) -- background matches popup

-- No-Ink: eInk-friendly monochrome highlights
-- Usage: require('noink').apply()

local M = {}

local function hl(grp, spec)
	vim.api.nvim_set_hl(0, grp, spec)
end

function M.apply()
	vim.o.termguicolors = false -- force TUI attrs

	---------------- Core UI ----------------
	hl("Normal", {}) -- plain text
	hl("CursorLine", { reverse = true })
	hl("LineNr", { italic = true })
	hl("CursorLineNr", { bold = true })
	hl("Visual", { reverse = true })

	---------------- Syntax -----------------
	-- Tree-sitter captures are just linked
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

	hl("Constant", { bold = true, underline = true })
	link("@constant", "Constant")
	link("@boolean", "Constant")
	link("@number", "Constant")
	link("@type", "Constant")

	hl("String", {}) -- keep clean
	link("@string", "String")

	hl("Operator", { bold = true })
	link("@operator", "Operator")

	--

	---------------- Diagnostics ------------
	hl("DiagnosticError", { bold = true, underline = false })
	hl("DiagnosticWarn", { bold = true })
	hl("DiagnosticInfo", { italic = true })
	hl("DiagnosticHint", { italic = true, underline = false })

	---------------- LSP Extras ------------
	hl("LspReferenceText", { reverse = true })
	hl("LspReferenceRead", { reverse = true })
	hl("LspReferenceWrite", { reverse = true, bold = true })

	---------------- Diff / Git ------------
	hl("DiffAdd", { underline = true })
	hl("DiffDelete", { strikethrough = true })
	hl("DiffChange", { bold = true })
	hl("DiffText", { reverse = true })
end

M.apply()