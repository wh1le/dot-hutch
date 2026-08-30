-- Explore:
--   https://github.com/ColinKennedy/neovim-ai-plugins
--   https://github.com/ThePrimeagen/99 -- ./disabled/99.lua
--   https://github.com/Exafunction/windsurf.vim

local hostname = vim.fn.hostname()

if not NM.hosts_with_ai[hostname] then
	return {}
end

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = "zbirenbaum/copilot.lua",
		config = function()
			require("copilot_cmp").setup()
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					require("copilot_cmp")._on_insert_enter()
				end,
			})
		end,
	},
	{
		-- https://github.com/avante-corp/avante.nvim
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"
		---@module 'avante'
		---@type avante.Config
		opts = {
			instructions_file = "avante.md",
			provider = "claude",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-20250514",
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
				moonshot = {
					endpoint = "https://api.moonshot.ai/v1",
					model = "kimi-k2-0711-preview",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 32768,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"folke/snacks.nvim", -- for input provider snacks
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "Avante" },
				},
				ft = { "Avante" },
			},
		},
	},
}
