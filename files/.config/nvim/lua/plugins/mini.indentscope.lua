return {
  "echasnovski/mini.indentscope",
  version = "*",
  config = function()
    require('mini.indentscope').setup({
      symbol = '╎',
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      }
    })
  end,
}
