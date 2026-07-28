-- Spelling
-- vim.keymap.set("n", "<leader>sn", "]s")
-- vim.keymap.set("n", "<leader>sp", "[s")
-- vim.keymap.set("n", "<leader>sa", "zg")
-- vim.keymap.set("n", "<leader>S?", "z=")

vim.g.spellfile_URL = "https://ftp.nluug.nl/pub/vim/runtime/spell"

local langs = { "en", "ru" }

-- Auto-download missing spell files (netrw may be unavailable on NixOS)
local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
local base_url = vim.g.spellfile_URL
for _, lang in ipairs(langs) do
	local spl = spell_dir .. "/" .. lang .. ".utf-8.spl"
	if vim.fn.filereadable(spl) == 0 then
		vim.fn.mkdir(spell_dir, "p")
		vim.fn.system({ "curl", "-fLo", spl, base_url .. "/" .. lang .. ".utf-8.spl" })
	end
end

vim.opt.spell = true
vim.opt.spelllang = langs

-- disable spell everywhere by default
-- vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, fg = "Black", bg="Gray" })

-- then configure treesitter highlights to use spell
-- vim.treesitter.query.set("python", "spell", [[
--   ((identifier) @spell)
--   ((function_definition name: (identifier) @spell))
--   ((class_definition name: (identifier) @spell))
-- ]])
