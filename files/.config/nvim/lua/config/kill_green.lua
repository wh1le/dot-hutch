local grey_rgb  = "#6e6e6e"
local grey_idx  = 8                    -- ANSI dark-grey slot

-- decode 0xRRGGBB integer → r,g,b numbers 0-255
local function int_to_rgb(int)
  local h = string.format("%06x", int) -- pad with zeros
  return tonumber(h:sub(1,2),16),
         tonumber(h:sub(3,4),16),
         tonumber(h:sub(5,6),16)
end

local function is_greenish(r,g,b)  return g > (r + b)  end

local function neutralise()
  for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })

    -- A) group has real RGB (guifg)
    if hl.fg then
      local r,g,b = int_to_rgb(hl.fg)
      if is_greenish(r,g,b) then
        vim.api.nvim_set_hl(0, name,
          { fg = grey_rgb, bg = hl.bg or "NONE", bold = hl.bold, italic = hl.italic })
      end

    -- B) group is only ANSI slot 2 (ctermfg = 2)
    elseif hl.ctermfg == 2 then
      vim.api.nvim_set_hl(0, name,
        { fg = grey_rgb, ctermfg = grey_idx, bg = hl.bg or "NONE" })
    end
  end
end

neutralise()                                            -- first pass
vim.api.nvim_create_autocmd({ "ColorScheme", "FileType", "Syntax", "BufWinEnter" },
  { callback = neutralise })

for _, grp in ipairs({
  "@string", "@string.regex", "@punctuation.special",  -- Treesitter
  "String", "SpecialChar",                             -- old Vim groups
}) do
  vim.api.nvim_set_hl(0, grp, { fg = "#6e6e6e" })      -- dark-grey
end

local kill = {
  -- nvim-tree
  "Directory",
  "NvimTreeFolderName",
  "NvimTreeFolderIcon",
  "NvimTreeOpenedFolderName",
  "NvimTreeRootFolder",

  -- functions / calls
  "Function", "@function", "@method", "@constructor",

  -- vars that sometimes inherit the same neon
  "Identifier", "@variable",
}

for _, grp in ipairs(kill) do
  vim.api.nvim_set_hl(0, grp, { fg = "Grey", bg = "NONE" })
end

-- append after all the previous “grey-ify” blocks
local grey = "#6e6e6e"

-- 1️⃣  Git signs  (⎸ green bar in signcolumn)
for _, grp in ipairs({
  "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
  "diffAdded", "DiffAdd",
}) do
  vim.api.nvim_set_hl(0, grp, { fg = grey, bg = "NONE" })
end

-- 2️⃣  Indent guides  (vertical rules)
for _, grp in ipairs({
  "IndentBlanklineChar",
  "IndentBlanklineContextChar",
  "IndentBlanklineSpaceChar",
}) do
  vim.api.nvim_set_hl(0, grp, { fg = grey, nocombine = true })
end

-- keep it sticky
vim.api.nvim_create_autocmd({ "ColorScheme", "User" }, {
  callback = function()
    -- rerun the two loops
    for _, g in ipairs({ "GitSignsAdd","GitSignsChange","GitSignsDelete",
                         "diffAdded","DiffAdd",
                         "IndentBlanklineChar","IndentBlanklineContextChar",
                         "IndentBlanklineSpaceChar"}) do
      vim.api.nvim_set_hl(0, g, { fg = grey, bg = "NONE", nocombine = true })
    end
  end,
})


-- Treesitter & LSP groups that Python maps to neon-green by default
local kill = {
  -- identifiers / calls
  "@function", "@function.call", "@method", "@method.call",
  "@function.builtin", "@variable.builtin",
  "@variable", "@parameter", "@field", "@property",

  -- types / classes
  "@type", "@class", "@constructor",
  "@lsp.type.class", "@lsp.type.function", "@lsp.type.method",
  "@lsp.type.variable", "@lsp.type.parameter",

  -- legacy Vim
  "Identifier",
}

local function greyify()
  for _, grp in ipairs(kill) do
    vim.api.nvim_set_hl(0, grp, { fg = grey, bg = "NONE", bold = false })
  end
end

greyify()  -- first pass

-- keep it applied after themes, Treesitter reloads, LSP attaches, etc.
vim.api.nvim_create_autocmd(
  { "ColorScheme", "BufWinEnter", "FileType", "User", "LspAttach" },
  { callback = greyify }
)
