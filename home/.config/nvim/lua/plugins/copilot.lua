local hostname = vim.fn.hostname()

if hostname ~= "mac" then
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
}
