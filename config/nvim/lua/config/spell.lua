-- Spelling
vim.keymap.set("n", "<leader>sn", "]s")
vim.keymap.set("n", "<leader>sp", "[s")
vim.keymap.set("n", "<leader>sa", "zg")
vim.keymap.set("n", "<leader>s?", "z=")

vim.opt.spell = true
vim.opt.spelllang = { "en" }

-- disable spell everywhere by default
-- vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, fg = "Black", bg="Gray" })

-- then configure treesitter highlights to use spell
-- vim.treesitter.query.set("python", "spell", [[
--   ((identifier) @spell)
--   ((function_definition name: (identifier) @spell))
--   ((class_definition name: (identifier) @spell))
-- ]])
