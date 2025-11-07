require("config.lsp.eslint")
require("config.lsp.json")
require("config.lsp.python")
require("config.lsp.typescript")
require("config.lsp.yaml")
require("config.lsp.ruby")
require("config.lsp.nix")
require("config.lsp.lua")

-- local lsp_mappings = {
-- 	{ "gD", vim.lsp.buf.declaration },
-- 	{ "gd", vim.lsp.buf.definition },
-- 	{ "gi", vim.lsp.buf.implementation },
-- 	{ "gr", vim.lsp.buf.references },
-- 	{ "[d", vim.diagnostic.goto_prev },
-- 	{ "]d", vim.diagnostic.goto_next },
-- 	{ "ll", vim.lsp.buf.hover },
-- 	{ "ls", vim.lsp.buf.signature_help },
-- 	-- { " d", vim.diagnostic.open_float },
-- 	-- { " q", vim.diagnostic.setloclist },
-- 	{ "\\r", vim.lsp.buf.rename },
-- 	{ "\\a", vim.lsp.buf.code_action },
-- }
-- for i, map in pairs(lsp_mappings) do
-- 	vim.keymap.set("n", map[1], function()
-- 		map[2]()
-- 	end)
-- end
-- vim.keymap.set("x", "\\a", function()
-- 	vim.lsp.buf.code_action()
-- end)
