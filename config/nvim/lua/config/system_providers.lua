vim.o.shell = "/bin/zsh"

-- languages
vim.g.perl_host_prog       = NM.language_providers.get_perl_path()
vim.g.loaded_perl_provider = 0
vim.g.python_host_prog     = NM.language_providers.get_python2_path()
vim.g.python3_host_prog    = NM.language_providers.get_python3_path()
vim.g.ruby_host_prog       = NM.language_providers.get_ruby_path()

-- open file
vim.g.netrw_browsex_viewer = NM.os.open_cmd_provider()
vim.ui.open                = NM.os.open_file
