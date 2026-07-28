vim.lsp.config.javascript = {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
	},
	root_markers = { "eslint.config.js", "package.json", ".git" },
	settings = {
		nodePath = "",
		experimental = {
			useFlatConfig = true,
		},
		workingDirectory = { mode = "location" },
		validate = "on",
		onIgnoredFiles = "off",
		format = false,
	},
	-- settings = {
	-- 	codeAction = {
	-- 		disableRuleComment = {
	-- 			enable = true,
	-- 			location = "separateLine",
	-- 		},
	-- 		showDocumentation = {
	-- 			enable = true,
	-- 		},
	-- 	},
	-- 	codeActionOnSave = {
	-- 		enable = false,
	-- 		mode = "all",
	-- 	},
	-- 	experimental = {
	-- 		useFlatConfig = false,
	-- 	},
	-- 	format = true,
	-- 	nodePath = "",
	-- 	onIgnoredFiles = "off",
	-- 	problems = {
	-- 		shortenToSingleLine = false,
	-- 	},
	-- 	quiet = false,
	-- 	rulesCustomizations = {},
	-- 	run = "onType",
	-- 	useESLintClass = false,
	-- 	validate = "on",
	-- workingDirectory = { mode = "location" },
	-- },
}

-- vtsls configured + enabled in typescript.lua (single TS/JS server)
vim.lsp.enable("javascript")
