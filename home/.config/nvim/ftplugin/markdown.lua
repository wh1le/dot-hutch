vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = false
vim.opt_local.conceallevel = 2
local ns = vim.api.nvim_create_namespace("hide_dvjs")

local function hide_dvjs(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local in_block, start = false, 0
  for i, l in ipairs(lines) do
    if not in_block and l:match("^%s*```%s*dataviewjs%s*$") then
      in_block, start = true, i - 1
    elseif in_block and l:match("^%s*```%s*$") then
      for j = start, i - 1 do
        local len = #lines[j + 1]
        vim.api.nvim_buf_set_extmark(0, ns, j, 0, { end_col = len, conceal = "" })
      end
      in_block = false
    elseif in_block then
      vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, { end_col = #l, conceal = "" })
    end
  end
end

vim.api.nvim_create_augroup("HideDvjs", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave", "BufWritePost" }, {
  group = "HideDvjs",
  pattern = { "*.md", "*.markdown", "*.mdx" },
  callback = function(a) hide_dvjs(a.buf) end,
})
