return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "mkdir -p $HOME/.npm-global/lib $HOME/.npm-global/bin && cd app && npx --yes yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_close = 1
			-- vim.g.mkdp_auto_close = 0
			-- vim.g.mkdp_auto_start = 0
			-- vim.g.mkdp_refresh_slow = 0

			vim.g.mkdp_theme = "dark"
		end,
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown: toggle browser preview" },
		},
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown", "rmd", "txt" },
		dependencies = { "godlygeek/tabular" },
		init = function()
			vim.g.table_mode_corner = "|"
			vim.g.table_mode_header_fillchar = "-"
			vim.g.table_mode_align_char = ":"
		end,
		keys = {
			{ "<leader>mtt", "<cmd>TableModeToggle<CR>", desc = "Table: toggle mode" },
			{ "<leader>mtr", "<cmd>TableModeRealign<CR>", desc = "Table: realign" },
			{ "<leader>mt|", "<cmd>Tableize /\\|<CR>", mode = { "n", "x" }, desc = "Tableize by | (MD)" },
			{ "<leader>mt,", "<cmd>Tableize /,<CR>", mode = { "n", "x" }, desc = "Tableize by , (CSV)" },
			{ "<leader>mt/", ":Tableize /", mode = "x", desc = "Tableize by custom regex…" },
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = false,
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown", "md", "codecompanion" },
				render_modes = { "n", "no", "c", "t", "i", "ic" },
				code = {
					sign = false,
					border = "thin",
					position = "right",
					width = "block",
					above = "▁",
					below = "▔",
					language_left = "█",
					language_right = "█",
					language_border = "▁",
					left_pad = 1,
					right_pad = 1,
				},
				heading = {
					sign = false,
					width = "block",
					left_pad = 1,
					right_pad = 0,
					position = "inline",
					icons = {},
				},
				bullet = {
					icons = { "●", "○", "▪", "▫" },
				},
				pipe_table = {
					preset = "round",
					alignment_indicator = "─",
				},
			})

			local function tune_markdown_bg()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				local base = string.format("#%06x", normal.bg or 0x000000)
				local Color = require("github-theme.lib.color")
				local shade = function(darken)
					return Color.from_hex(base):shade(-darken):to_css()
				end
				local body = shade(0.18)
				local edge = shade(0.10)
				vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = body })
				vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = body })
				vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { bg = edge })
				vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", { bg = edge })
				for level = 1, 6 do
					vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { bg = body })
				end
			end

			tune_markdown_bg()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = tune_markdown_bg })
		end,
	},
	{
		"YousefHadder/markdown-plus.nvim",
		ft = { "markdown" },
		config = function()
			require("markdown-plus").setup({
				filetypes = { "markdown" },
				features = {
					list_management = true,
					text_formatting = true,
					thematic_break = false,
					links = false,
					images = false,
					headers_toc = false,
					quotes = false,
					callouts = false,
					code_block = false,
					html_block_awareness = true,
					table = true,
					footnotes = false,
				},
			})
		end,
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		enabled = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			-- core
			{ "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian app" },
			{ "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian: new note" },
			{ "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New from template" },
			{ "<leader>ob", "<cmd>Obsidian quick_switch<CR>", desc = "Quick Switch" },
			{ "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search / create" },
			{ "<leader>oT", "<cmd>Obsidian template<CR>", desc = "Insert template" },

			-- daily
			{ "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Obsidian: today" },
			{ "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Obsidian: yesterday" },
			{ "<leader>op", "<cmd>Obsidian tomorrow<CR>", desc = "Obsidian: tomorrow" },
			{ "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Obsidian: Dailies" },

			-- follow
			{ "<leader>of", "<cmd>Obsidian follow_link<CR>", desc = "Obsidian: follow" },
			{ "<leader>ofv", "<cmd>Obsidian follow_link vsplit<CR>", desc = "Obsidian: follow (vertical)" },
			{ "<leader>ofh", "<cmd>Obsidian follow_link hsplit<CR>", desc = "Obsidian: follow (horizontal)" },

			-- workspaces
			{ "<leader>ow", "<cmd>Obsidian workspace<CR>", desc = "Obsidian: pick workspace" },
		},
		opts = {
			legacy_commands = false,
			ui = {
				enable = false,
			},
			checkbox = {
				order = { " ", "x" },
			},
			frontmatter = {
				sort = { "id", "aliases", "tags" },
			},
			open = {
				schemes = { "https", "http", "file", "mailto" },
			},
			attachments = {
				folder = "_attachments",
				confirm_img_paste = false,
			},
			file = {
				ignore_filters = { "archive", "private/**", "templates/**" },
			},
			cache = {
				enabled = true,
			},
			picker = {
				name = "telescope.nvim",
			},
			workspaces = {
				{
					name = "Personal",
					path = vim.fn.expand("~/Documents/obsidian/self-architect"),
				},
			},
			workspaces = {
				{
					name = "Work",
					path = vim.fn.expand("~/Documents/obsidian/Work"),
				},
			},
			completion = {
				min_chars = 2,
			},
			callbacks = {
				enter_note = function(note)
					vim.keymap.set("n", "<leader>ox", "<cmd>Obsidian toggle_checkbox<CR>", {
						buffer = true,
						desc = "Obsidian: toggle checkbox",
					})
					vim.keymap.set("n", "<leader>wf", require("obsidian.api").smart_action, {
						buffer = true,
						desc = "Obsidian: smart action",
					})
				end,
			},
			link = {
				style = "wiki",
				format = "shortest",
			},
		},
	},
}
