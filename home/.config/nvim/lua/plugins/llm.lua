-- Explore:
--   https://github.com/ColinKennedy/neovim-ai-plugins
--   https://github.com/ThePrimeagen/99 -- ./disabled/99.lua
--   https://github.com/Exafunction/windsurf.vim

local hostname = vim.fn.hostname()

local plugins = {
	-- {
	-- 	"pablopunk/pi.nvim",
	-- 	init = function()
	-- 		-- Force notify backend: pi.nvim uses vim.notify (snacks.notifier)
	-- 		-- instead of its hardcoded centered status float.
	-- 		_G.__pi_force_notify_backend = true
	-- 	end,
	-- 	keys = {
	-- 		{ "<leader>lu", ":PiAsk<CR>", mode = "n", desc = "Ask pi" },
	-- 		{ "<leader>lu", ":PiAskSelection<CR>", mode = "v", desc = "Ask pi (selection)" },
	-- 	},
	-- 	opts = {
	-- 		-- binary = "~/.bin/pi", -- or { "env", "FOO=1", "pi-wrapper" }
	-- 		provider = "fireworks",
	-- 		model = "accounts/fireworks/models/glm-5p3",
	-- 		thinking = "medium",
	-- 		tools = { "bash" },
	-- 		system_prompt = "You are a helpful assistant.",
	-- 		append_system_prompt = "Always respond concisely.",
	-- 		context = {
	-- 			max_bytes = 24000,
	-- 			ask = {
	-- 				surrounding_lines = 80,
	-- 			},
	-- 			selection = {
	-- 				surrounding_lines = 40,
	-- 			},
	-- 			diagnostics = {
	-- 				enabled = true,
	-- 			},
	-- 		},
	-- 		skills = true,
	-- 		extensions = true,
	-- 	},
	-- },
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
		-- {
		-- 	-- https://github.com/avante-corp/avante.nvim
		-- 	"yetone/avante.nvim",
		-- 	event = "VeryLazy",
		-- 	build = "make",
		-- 	version = false, -- Never set this value to "*"
		-- 	keys = {
		-- 		{ "<leader>lu", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Ask avante" },
		-- 		{ "<leader>le", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Edit selection (avante)" },
		-- 	},
		-- 	opts = {
		-- 		instructions_file = "avante.md",
		-- 		provider = "gateway",
		-- 		providers = {
		-- 			gateway = {
		-- 				__inherited_from = "openai",
		-- 				endpoint = "https://ai-gateway.zende.sk/openai/v1",
		-- 				api_key_name = "AI_GATEWAY_ACCESS_TOKEN",
		-- 				model = "accounts/fireworks/models/glm-5p3",
		-- 				timeout = 30000,
		-- 				extra_request_body = {
		-- 					-- temperature = 0.75,
		-- 					max_tokens = 32768,
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"MunifTanjim/nui.nvim",
		-- 		"nvim-telescope/telescope.nvim",
		-- 		"hrsh7th/nvim-cmp",
		-- 		"ibhagwan/fzf-lua",
		-- 		"folke/snacks.nvim",
		-- 		"zbirenbaum/copilot.lua",
		-- 		{
		-- 			"HakonHarnes/img-clip.nvim",
		-- 			event = "VeryLazy",
		-- 			opts = {
		-- 				default = {
		-- 					embed_image_as_base64 = false,
		-- 					prompt_for_file_name = false,
		-- 					drag_and_drop = {
		-- 						insert_mode = true,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 		{
		-- 			"MeanderingProgrammer/render-markdown.nvim",
		-- 			opts = {
		-- 				file_types = { "Avante" },
		-- 			},
		-- 			ft = { "Avante" },
		-- 		},
		-- 	},
		-- },
	})
end

return plugins
