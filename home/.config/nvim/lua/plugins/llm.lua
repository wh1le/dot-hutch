-- Explore:
--   https://github.com/ColinKennedy/neovim-ai-plugins
--   https://github.com/ThePrimeagen/99 -- ./disabled/99.lua
--   https://github.com/Exafunction/windsurf.vim

local hostname = vim.fn.hostname()

local plugins = {
	{
		"pablopunk/pi.nvim",
		opts = {},
	},
}

if NM.hosts_with_ai[hostname] then
	vim.list_extend(plugins, {
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
						timeout = 30000,
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
				"nvim-telescope/telescope.nvim",
				"hrsh7th/nvim-cmp",
				"ibhagwan/fzf-lua",
				"folke/snacks.nvim",
				"zbirenbaum/copilot.lua",
				{
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
	})
end

return plugins
