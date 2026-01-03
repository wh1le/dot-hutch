vim.lsp.config.javascript = {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
	},
	root_markers = { ".eslintrc.json", "package.json", "tsconfig.json", ".git" },
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

vim.lsp.enable("javascript")
