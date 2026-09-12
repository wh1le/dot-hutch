vim.lsp.config.autotools_ls = {
	cmd = { "autotools-language-server" },
	filetypes = { "make", "automake", "config" },
	root_markers = { "Makefile", "makefile", "GNUmakefile", "Makefile.am", "configure.ac", ".git" },
}

vim.lsp.enable("autotools_ls")
