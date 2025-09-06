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
		-- 1️⃣  Saga default float
		-- { "<leader>cr", "<cmd>Lspsaga lsp_rename<CR>", desc = "Saga: default lsp_rename" },

		-- 2️⃣  Saga float, cursor jumps to INSERT
		-- { "<leader>cr", "<cmd>Lspsaga lsp_rename mode=i<CR>", desc = "Saga: rename (mode=i)" },

		-- 3️⃣  Saga float, SELECT word (visual-style)
		-- { "<leader>cr", "<cmd>Lspsaga lsp_rename mode=s<CR>", desc = "Saga: rename (mode=s)" },

		-- 4️⃣  Saga float + ripgrep sweep for leftovers
		-- { "<leader>cr", "<cmd>Lspsaga lsp_rename ++project<CR>", desc = "Saga: rename ++project" },

		-- 5️⃣  Saga, SELECT mode **and** RG sweep
		-- { "<leader>cr", "<cmd>Lspsaga lsp_rename mode=s ++project<CR>", desc = "Saga: rename s + project" },

		-- this one works with file rename!!!!
		-- 6️⃣  Plain Neovim LSP (no Saga UI)
		-- {
		-- 	"<leader>cr",
		-- 	function()
		-- 		vim.lsp.buf.rename()
		-- 	end,
		-- 	desc = "Built-in: vim.lsp.buf.rename()",
		-- },

		-- Attemps to fix replace
		-- {
		-- 	"<leader>cx",
		-- 	function()
		-- 		local params = vim.lsp.util.make_position_params()
		-- 		params.newName = vim.fn.input("New name: ")
		-- 		vim.lsp.buf_request(0, "textDocument/rename", params, vim.lsp.util.apply_workspace_edit)
		-- 	end,
		-- },
		-- vim.lsp.buf_request_sync(0, "textDocument/rename", params)
		-- {
		-- 	"<leader>cr",
		-- 	-- "<cmd>Lspsaga rename ++project<CR>",
		-- 	"<cmd>Lspsaga lsp_rename ++project<CR>",
		-- 	desc = "Saga: rename symbol",
		-- },
		-- pure RG search & replace (good for strings / paths)
		-- {
		-- 	"<leader>rN",
		-- 	function()
		-- 		vim.lsp.buf.rename()
		-- 	end,
		-- 	desc = "LSP: rename symbol (vanilla)",
		-- },
		-- -- { "<leader>cR", "<cmd>Lspsaga project_replace<CR>", desc = "Saga: project replace" },
		-- {
		-- 	"<leader>cR",
		-- 	function()
		-- 		local old = vim.fn.expand("<cword>")
		-- 		vim.ui.input({ prompt = "replace " .. old .. " with → " }, function(new)
		-- 			if new and #new > 0 then
		-- 				vim.cmd(("Lspsaga project_replace %s %s"):format(old, new))
		-- 			end
		-- 		end)
		-- 	end,
		-- 	desc = "Saga: project replace word",
		-- },
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
					exec = "<CR>",
				},
			},
			lightbulb = {
				enable = false, -- master switch
				sign = false, -- no sign-column icon
				virtual_text = false, -- no “💡” at line end
			},
			symbol_in_winbar = {
				enable = false,
        show_file = true,
        color_mode = false,
        delay = 300,
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
	end,
}
