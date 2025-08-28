return {
	"janko/vim-test",
  enabled  = false,
	init = function()
		vim.g["test#custom_strategies"] = {
			pytest_s = function(cmd)
				return cmd .. " -s"
			end,
		}

		vim.g["test#python#pytest#options"] = "-s --color=no"
		vim.cmd("let $TERM = 'xterm-256color'")
		vim.o.shell = "/bin/zsh"
		vim.g["test#python#pytest#executable"] = "~/.zsh/bin/nocolor-pytest"
	end,
	keys = {
		-- Run nearest test
		{ "<leader>ts", "<cmd>TestNearest<CR>", desc = "Test: Nearest" },
		-- Run file tests
		{ "<leader>tf", "<cmd>TestFile<CR>", desc = "Test: File" },
		-- Run last test
		{ "<leader>tl", "<cmd>TestLast<CR>", desc = "Test: Last" },
		-- Run all test suite
		{ "<leader>tr", "<cmd>TestSuite<CR>", desc = "Test: Suite" },
		-- Visit test output
		{ "<leader>to", "<cmd>TestVisit<CR>", desc = "Test: Visit output" },
	},
}
