return {
	"stevearc/overseer.nvim",
	opts = {
		strategy = "terminal",
		version = "v1.6.0",
	},
	config = function(_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)

		-- vim.keymap.set("n", "<leader>r", function()
		-- 	overseer
		-- 		.new_task({
		-- 			cmd = { vim.fn.expand("%:p") }, -- current file, OS uses shebang
		-- 			components = {
		-- 				{ "open_output", direction = "float", focus = true },
		-- 				"default",
		-- 			},
		-- 		})
		-- 		:start()
		-- end, { desc = "Overseer: run current file (shebang -> quickfix)" })
	end,
}
