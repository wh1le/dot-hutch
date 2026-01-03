NM.language_providers = {
  get_binary_path = function(name)
    return vim.fn.trim(
      vim.fn.exepath(name)
    )
  end
  -- get_perl_path = function()
  --   return vim.fn.trim(
  --     vim.fn.exepath('perl')
  --   )
  -- end,
  --
  -- get_python2_path = function()
  --   return vim.fn.trim(
  --     vim.fn.exepath('python')
  --   )
  -- end,
  --
  -- get_python3_path = function()
  --   return vim.fn.trim(
  --     vim.fn.exepath('python3')
  --   )
  -- end,
  --
  -- get_ruby_path = function()
  --   return vim.fn.trim(
  --     vim.fn.exepath('ruby')
  --   )
  -- end
}
