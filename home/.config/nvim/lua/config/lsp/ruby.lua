local ruby_root_markers = {
	".git",
	"Gemfile",
	"Rakefile",
	".rubocop",
	".rubocop.yml",
}

vim.lsp.config.ruby_lsp = {
	cmd = { "ruby-lsp" },
	filetypes = { "ruby", "spec", "ruby.spec", "rake" },
	root_markers = ruby_root_markers,
}

vim.lsp.config.rubocop = {
	cmd = { "rubocop" },
	filetypes = { "ruby", "spec", "ruby.spec", "rake" },
	root_markers = ruby_root_markers,
}

vim.lsp.enable("ruby_lsp")
