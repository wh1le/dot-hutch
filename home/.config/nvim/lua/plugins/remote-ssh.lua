return {
	"amitds1997/remote-nvim.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteLog" },
	keys = {
		{ "<leader>rc", "<cmd>RemoteStart<CR>", desc = "Remote Connect" },
		{ "<leader>rd", "<cmd>RemoteStop<CR>", desc = "Remote Disconnect" },
		{ "<leader>ri", "<cmd>RemoteInfo<CR>", desc = "Remote Info" },
	},
	config = true,
	opts = {
		client_callback = function(port, workspace_config)
			local cmd = ("nvim --server localhost:%s --remote-ui"):format(port)
			if workspace_config.workspace then
				cmd = cmd .. " +cd\\ " .. workspace_config.workspace
			end
			vim.fn.jobstart(cmd, { detach = true })
		end,
	},
}
