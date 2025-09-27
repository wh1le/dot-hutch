vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo.filetype
    if not ft:match("javascript") and not ft:match("typescript") then return end
    if ft:match("jest") then return end

    local file = args.file or vim.api.nvim_buf_get_name(0)

    if file:match("(_spec|Spec|%-test|%.test)%.(js[x]?|ts[x]?)$") or
       file:match("/__tests__/") or file:match("tests?/.*%.(js[x]?|ts[x]?)$") then
      vim.cmd("noautocmd set filetype+=.jest")
    end
  end,
})
