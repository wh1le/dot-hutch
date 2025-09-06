return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	enabled = true,
	event = {
		"BufReadPre /mnt/c/Obsidian/self-architect/*.md",
		"BufNewFile /mnt/c/Obsidian/self-architect/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		-- core
		{ "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Open in Obsidian app" },
		{ "<leader>on", "<cmd>ObsidianNew<CR>", desc = "Obsidian: new note" },
		{ "<leader>oN", "<cmd>ObsidianNewFromTemplate<CR>", desc = "New from template" },
		{ "<leader>ob", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch" },
		{ "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search / create" },
		{ "<leader>oT", "<cmd>ObsidianTemplate<CR>", desc = "Insert template" },

		-- daily
		{ "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "Obsidian: today" },
		{ "<leader>oy", "<cmd>ObsidianYesterday<CR>", desc = "Obsidian: yesterday" },
		{ "<leader>op", "<cmd>ObsidianTomorrow<CR>", desc = "Obsidian: tomorrow" },
		{ "<leader>od", "<cmd>ObsidianDailies<CR>", desc = "Obsidian: Dailies" },

		-- follow
		{ "<leader>of", "<cmd>ObsidianFollowLink<CR>", desc = "Obsidian: follow" },
		{ "<leader>ofv", "<cmd>ObsidianFollowLink vsplit<CR>", desc = "Obsidian: follow (vertical)" },
		{ "<leader>ofh", "<cmd>ObsidianFollowLink hsplit<CR>", desc = "Obsidian: follow (horizontal)" },

		-- links
		-- { "<leader>oK", "<cmd>ObsidianLinks<CR>",        desc = "Obsidian: list links" },
		-- { "<leader>ol", "<cmd>ObsidianLink<CR>",         mode = "x", desc = "Obsidian: link selection" },
		-- { "<leader>oL", "<cmd>ObsidianLinkNew<CR>",      mode = "x", desc = "Obsidian: link NEW from selection" },
		-- { "<leader>ox", "<cmd>ObsidianExtractNote<CR>",  mode = "x", desc = "Obsidian: extract selection -> note" },
		-- { "<leader>ob", "<cmd>ObsidianBacklinks<CR>",    desc = "Obsidian: backlinks" },
		-- { "<leader>og", "<cmd>ObsidianTags<CR>",         desc = "Obsidian: tags" },
		-- { "<leader>oI", "<cmd>ObsidianTOC<CR>",          desc = "Obsidian: table of contents" },

		-- workspaces
		{ "<leader>ow", "<cmd>ObsidianWorkspace<CR>", desc = "Obsidian: pick workspace" },

		-- text
		-- { "<leader>o<CR>", "<cmd>ObsidianToggleCheckbox<CR>", mode = "n", desc = "Obsidian: toggle checkbox" }
		-- { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
		-- { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename (update backlinks)" },
		-- { "<leader>ow", "<cmd>ObsidianWorkspace <space>", desc = "Switch workspace" },
	},
	opts = {
    ui = {
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      }
    },
		picker = {
			name = "fzf-lua",
		},
		img_folder = "_attachments",
		workspaces = {
			{
				name = "self-architect",
				path = "/mnt/c/Obsidian/self-architect/",
			},
			{
				name = "work",
				path = "/mnt/c/Obsidian/public/",
			},
		},
		templates = { subdir = "_service/templates" },
		daily_notes = {
			folder = "2 — Logs/Day",
			date_format = "%Y/%m/%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = "day.md",
		},
		completion = {
			nvim_cmp = true, -- Set to false to disable completion.
			min_chars = 2, -- Trigger completion at 2 chars.
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>tt"] = { -- Toggle check-boxes.
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<leader>wf"] = { -- Smart action depending on context, either follow link or toggle checkbox.
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		new_notes_location = "0    —  Инбокс",
		preferred_link_style = "wiki",
	},
}
