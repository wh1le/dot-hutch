return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      definition = {
        keys = {
          edit = 'o'
        }
      },
      diagnostic = {
        max_height = 0.8,
        keys = {
            quit = {'q', '<ESC>'}
        }
      },
    })
    require('lspsaga.symbol.winbar').get_bar()
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  }
}
