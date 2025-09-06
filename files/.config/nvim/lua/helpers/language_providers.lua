NM.language_providers = {
  get_perl_path = function()
    return vim.fn.trim(
      vim.fn.system("which perl")
    )
  end,

  get_python2_path = function()
    return vim.fn.trim(
      vim.fn.system("which python")
    )
  end,

  get_python3_path = function()
    return vim.fn.trim(
      vim.fn.system("pyenv which python3")
    )
  end,

  get_ruby_path = function()
    vim.fn.expand("~/.rbenv/shims/ruby")
  end
}
