NM.tests = {
  in_spec = function(path)
    return path:match("^spec/")
  end,

  file_exists = function(path)
    return vim.loop.fs_stat(path) ~= nil
  end,

  toggle = function()
    local abs = vim.api.nvim_buf_get_name(0)
    if abs == "" then
      return
    end

    local rel = vim.fn.fnamemodify(abs, ":.")
    local target

    if NM.tests.in_spec(rel) then
      target = rel:gsub("^spec/", ""):gsub("_spec%.rb$", ".rb")
      if not target:match("^lib/") then
        target = "app/" .. target
      end
    else
      target = rel:gsub("^app/", ""):gsub("%.rb$", "_spec.rb")
      target = "spec/" .. target
    end

    if not NM.tests.file_exists(target) then
      local ok = vim.fn.confirm("Create " .. target .. "?", "&Yes\n&No", 2)
      if ok == 1 then
        vim.fn.mkdir(vim.fn.fnamemodify(target, ":h"), "p")
        vim.cmd.edit(target)
      end
    else
      vim.cmd.edit(target)
    end
  end
}
