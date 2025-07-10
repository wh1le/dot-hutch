return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"lua",
			"python",
			"javascript",
			"typescript",
			"ruby",
			"tsx",
			"html",
			"yaml",
			"toml",
			"bash",
			"dockerfile",
			"markdown",
			"gitcommit",
			"make",
		},
		indent = { enable = true },
		highlight = { enable = true },
		auto_install = true,
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-n>",
					node_incremental = "<C-n>",
					node_decremental = "<C-h>",
					scope_incremental = "<C-s>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- auto-jump forward to textobj
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[c"] = "@class.outer",
					},
				},
			},
		})

		-- vim.o.foldmethod = "expr"
		-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		-- vim.opt.foldlevel = 99
		-- vim.opt.foldlevelstart = 99 -- prevents folding on open
    --
		-- vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		vim.cmd("normal! zR")
		-- 	end,
		-- })

		-- 🧠 Boldify function names in Treesitter + Aerial
		local hl = vim.api.nvim_set_hl
		hl(0, "@function", { bold = true })
		hl(0, "@method", { bold = true })
		hl(0, "@lsp.type.function", { link = "Function", bold = true })
		hl(0, "@lsp.type.method", { link = "Function", bold = true })

		hl(0, "AerialFunction", { bold = true })
		hl(0, "AerialMethod", { bold = true })
	end,
}
