return {
  "tpope/vim-surround",
  config = function()
    ------------------------------------------------------------------
    -- 1️⃣  Default visual mapping
    ------------------------------------------------------------------
    vim.keymap.set(
      "v",
      "Si",
      "S(i_<Esc>f)",           -- wrap selection in “( … )” then jump after “(”
      { noremap = true }
    )

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "mako",
      callback = function()
        vim.keymap.set(
          "v",
          "Si",
          'S"i${ _(<Esc>2f"a) }<Esc>',  -- custom surround for mako
          { noremap = true, buffer = true }
        )
      end,
    })
  end,
}
