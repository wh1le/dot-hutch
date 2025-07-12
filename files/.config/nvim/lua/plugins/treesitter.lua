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
		highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
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
    auto_install = true,
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
