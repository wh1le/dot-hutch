vim.o.shell = NM.language_providers.get_binary_path("zsh")

-- languages
-- vim.g.loaded_perl_provider = 0
vim.g.perl_host_prog = NM.language_providers.get_binary_path("perl")
vim.g.python_host_prog = NM.language_providers.get_binary_path("python2")
vim.g.python3_host_prog = NM.language_providers.get_binary_path("python3")
vim.g.ruby_host_prog = NM.language_providers.get_binary_path("ruby")

-- open file
vim.g.netrw_browsex_viewer = NM.os.open_cmd_provider()
vim.ui.open = NM.os.open_file
