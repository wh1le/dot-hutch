vim.lsp.config.ruby = {
	cmd = { "ruby-lsp" },
	filetypes = { "ruby", "spec", "ruby.spec" },
	root_markers = {
		".git",
		"Gemfile",
		"Rakefile",
	},
}

vim.lsp.enable("ruby")
