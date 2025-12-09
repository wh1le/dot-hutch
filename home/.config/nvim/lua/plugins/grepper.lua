return {
	"mhinz/vim-grepper",
	lazy = false,
	config = function()
		vim.g.grepper = {
			tools = { "rg", "vimgrep", "grep", "git" }, -- Order of preference
			searchreg = 1, -- Use last search register
			highlight = 1, -- Highlight matches
			quickfix = 1, -- Use quickfix list
			open = 1, -- Auto-open quickfix
			switch = 1, -- Switch to quickfix window
			jump = 0, -- Don't auto-jump to first match
			prompt = 1, -- Show search prompt
		}

		-- Keybindings
		vim.keymap.set("n", "<leader>g", "<cmd>Grepper<CR>", { desc = "Grepper search" })
		vim.keymap.set("n", "<leader>sw", "<cmd>Grepper -cword -noprompt<CR>", { desc = "Search word under cursor" })
		vim.keymap.set("n", "<leader>sb", "<cmd>Grepper -buffers<CR>", { desc = "Search in buffers" })

		-- Visual mode: search selected text
		vim.keymap.set("x", "sw", "<plug>(GrepperOperator)", { desc = "Grepper operator" })
	end,
	keys = {
		{ "<leader>g", desc = "Grepper search" },
		{ "<leader>g", desc = "Search word" },
		{ "<leader>sb", desc = "Search buffers" },
	},
}
