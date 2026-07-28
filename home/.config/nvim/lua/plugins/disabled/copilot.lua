return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true, -- Never loads at startup
		cmd = "Copilot",
		keys = {
			{
				"<leader>cp",
				function()
					-- Load the plugin if not loaded yet
					if not package.loaded["copilot"] then
						require("lazy").load({ plugins = { "copilot.lua" } })
					end

					if require("copilot.client").is_disabled() then
						require("copilot.command").enable()
						vim.notify("Copilot ENABLED", vim.log.levels.INFO)
					else
						require("copilot.command").disable()
						vim.notify("Copilot DISABLED (no data sent)", vim.log.levels.INFO)
					end
				end,
				desc = "Toggle Copilot",
				mode = "n",
			},
		},
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false, auto_trigger = false },
				panel = { enabled = false },

				filetypes = {
					markdown = true,
					help = true,
				},

				should_attach = function() -- privacy: do not read all my files!
					return not require("copilot.client").is_disabled()
				end,
			})
		end,
	},

	{
		"zbirenbaum/copilot-cmp",
		lazy = true,
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
