NM.quit = {
  with_prompt = function()
    if vim.fn.confirm("Quit Neovim?", "&Yes\n&No", 2) == 1 then
      vim.cmd("confirm qa")  -- will also ask to save modified files
    end
  end
}
