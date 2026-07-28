return {
  "vimwiki/vimwiki",
  enabled = false,
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/vimwiki",
        syntax = "markdown",
        ext = ".md",
      }
    },

    vim.keymap.set('n', '<leader>tt', '<Plug>VimwikiToggleListItem')
    vim.keymap.set('n', '<leader>wf', '<Plug>VimwikiFollowLink')
    vim.keymap.set('n', '<leader>wq', '<Plug>VimwikiVSplitLink')
  end,
}
