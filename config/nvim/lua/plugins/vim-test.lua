return {
	"janko/vim-test",
	keys = {
	  { "<leader>tr", "<cmd>TestLast<CR>", desc = "Test: Last" },
	  { "<leader>ts", "<cmd>TestNearest<CR>", desc = "Test: Nearest" },
	  { "<leader>tt", "<cmd>TestFile<CR>", desc = "Test: File" },
	  { "<leader>tr", "<cmd>TestSuite<CR>", desc = "Test: Suite" },
	  { "<leader>to", "<cmd>TestVisit<CR>", desc = "Test: Visit output" },
	},
	init = function()

		vim.g["test#strategy"] = "make"

    -- ruby
    local ruby_formatter = vim.fn.expand("~/.config/nvim/support/vim_formatter.rb")
    local opts = {
      "--no-color",
      "--require " .. vim.fn.shellescape(ruby_formatter),
      "--format VimFormatter",
    }
     vim.g["test#ruby#rspec#options"] = table.concat(opts, " ")

    -- python
		vim.g["test#python#pytest#executable"] = "pytest"
		vim.g["test#python#pytest#options"] = "-s --color=no"
    -- vim.bo.errorformat = table.concat({
    --   -- top-level only for project files (relative paths)
    --   "%E%\\./%f:%l:%c:%m",
    --   "%E%\\./%f:%l:%m",
    --
    --   -- make gem/rbenv frames children (not new items)
    --   "%C%~/.rbenv/%\\f%#:%l:%c%\\s%#%m",
    --   "%C%~/.rbenv/%\\f%#:%l%\\s%#%m",
    --
    --   -- rspec context/body as children
    --   "%CFailure/Error:%\\s%m",
    --   "%Cin '%m'",
    --   "%C%\\s%#%m",
    --
    --   -- drop anything else
    --   "%-G%.%#",
    -- }, ",")
	end,
}


-- In quick fix I want it to look like this:
--
-- -> Spec file name
--   -> test name, status
--     -> errors and points to file where it happends
--   -> test name, status
--   -> test name, status
--   -> test name, status
-- -> 
