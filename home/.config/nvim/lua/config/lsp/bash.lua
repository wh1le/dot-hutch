vim.lsp.config.bash = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc|.zshenv)",
		},
	},
}

vim.lsp.enable("bash")
