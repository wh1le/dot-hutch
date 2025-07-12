return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
	lazy = false,
	-- after = "nvim-lspconfig",
	keys = {
		-- 🔍 Go to definition (opens the real file)
		{
			"gd",
			"<cmd>Lspsaga goto_definition<CR>",
			desc = "Lspsaga: Goto Definition",
			mode = "n",
			silent = true,
		},
		-- 👀 Preview definition (floating window, no jump)
		{
			"gp",
			"<cmd>Lspsaga peek_definition<CR>",
			desc = "Lspsaga: Peek Definition",
			mode = "n",
			silent = true,
		},
		{
			"gt",
			"<cmd>Lspsaga peek_type_definition<CR>",
			desc = "Lspsaga: Preview Type Definition",
			mode = "n",
			silent = true,
		},
		{ "<leader>cr", "<cmd>Lspsaga rename ++project<CR>", desc = "Saga: rename symbol" },
		-- pure RG search & replace (good for strings / paths)
		{
			"<leader>rN",
			function()
				vim.lsp.buf.rename()
			end,
			desc = "LSP: rename symbol (vanilla)",
		},
		-- { "<leader>cR", "<cmd>Lspsaga project_replace<CR>", desc = "Saga: project replace" },
		{
			"<leader>cR",
			function()
				local old = vim.fn.expand("<cword>")
				vim.ui.input({ prompt = "replace " .. old .. " with → " }, function(new)
					if new and #new > 0 then
						vim.cmd(("Lspsaga project_replace %s %s"):format(old, new))
					end
				end)
			end,
			desc = "Saga: project replace word",
		},
	},
	config = function()
		require("lspsaga").setup({
			use_cmp = true,
			code_action = {
				enable = false,
			},
			rename = {
				in_select = true, -- text pre-selected in prompt
				auto_save = true, -- write buffers after rename
				keys = {
					-- exec = "<C-s>", -- this replaces broken <C-CR>
				},
			},
			lightbulb = {
				enable = false, -- master switch
				sign = false, -- no sign-column icon
				virtual_text = false, -- no “💡” at line end
			},
			symbol_in_winbar = {
				enable = true,
			},
			diagnostic = {
				show_code_action = false,
			},
			code_action_prompt = {
				enable = false,
			},
			-- definition = {
			-- 	keys = {
			-- 		edit = "o",
			-- 	},
			-- },
			-- diagnostic = {
			-- 	max_height = 0.8,
			-- 	keys = {
			-- 		quit = { "q", "<ESC>" },
			-- 	},
			-- },
		})
		-- require("lspsaga.symbol.winbar").get_bar()
	end,
}
