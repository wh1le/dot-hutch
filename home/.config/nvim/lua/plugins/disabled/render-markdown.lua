return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {
		render_modes = { "n", "c", "i" },
		heading = {
			enabled = true,
			sign = false,
			backgrounds = {},
		},
		code = {
			enabled = true,
			sign = false,
			style = "language",
			disable_background = true,
		},
		pipe_table = { enabled = true, style = "full" },
		checkbox = { enabled = true },
		win_options = {
			-- conceallevel = {
			--   -- default = vim.o.conceallevel,
			--   rendered = 2
			-- },
		},
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)
		-- cterm-friendly highlights (no guibg needed)
		local hl = vim.api.nvim_set_hl
		hl(0, "RenderMarkdownH1", { ctermfg = 4, bold = true })
		hl(0, "RenderMarkdownH2", { ctermfg = 6, bold = true })
		hl(0, "RenderMarkdownH3", { ctermfg = 2, bold = true })
		hl(0, "RenderMarkdownH4", { ctermfg = 3, bold = true })
		hl(0, "RenderMarkdownH5", { ctermfg = 5, bold = true })
		hl(0, "RenderMarkdownH6", { ctermfg = 8, bold = true })
		hl(0, "RenderMarkdownCode", { ctermbg = 0 })
		hl(0, "RenderMarkdownCodeInline", { ctermfg = 3 })
		hl(0, "RenderMarkdownTableHead", { ctermfg = 4, bold = true })
		hl(0, "RenderMarkdownTableRow", { ctermfg = 7 })
		hl(0, "RenderMarkdownLink", { ctermfg = 4, underline = true })
		hl(0, "RenderMarkdownWikiLink", { ctermfg = 6, underline = true })
	end,
}
