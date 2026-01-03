-- Scan first 500 lines for "<React>"
local function scan_file_for_react()
  local max = math.min(vim.fn.line("$"), 500)
  for n = 1, max do
    if vim.fn.getline(n):match("<React>") then
      return true
    end
  end
  return false
end

-- Detect JSX pattern and adjust filetype
local function detect_jsx()
  if vim.bo.filetype:match("jsx") then return end
  if scan_file_for_react() then
    vim.cmd("noautocmd set filetype+=.jsx")
  end
end

-- Filetype for .js.jsx
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.js.jsx",
  callback = function()
    vim.cmd("noautocmd set filetype+=.jsx")
  end,
})

-- Run JSX detection on HTML and JS files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.html", "*.js" },
  callback = detect_jsx,
})
