return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    -- never use the "indent" provider (it’s the one crashing)
    provider_selector = function(bufnr, filetype, buftype)
      local has_ts = pcall(vim.treesitter.get_parser, bufnr)
      local has_lsp = #vim.lsp.get_clients({ bufnr = bufnr }) > 0
      if has_lsp and has_ts then return { "lsp", "treesitter" }
      elseif has_lsp then return "lsp"
      elseif has_ts then return "treesitter"
      else return {} -- disable ufo for this buffer
      end
    end,
  },
  config = function(_, opts)
    require("ufo").setup(opts)
  end,
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "UFO: open all folds", mode = "n", silent = true },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "UFO: close all folds", mode = "n", silent = true },
    { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "UFO: peek fold", mode = "n", silent = true },
  },
}

