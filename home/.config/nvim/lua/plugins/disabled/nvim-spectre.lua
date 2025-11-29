-- local function get_root()
--   local clients = vim.lsp.get_active_clients({ bufnr = 0 })
--   if next(clients) ~= nil then
--     return clients[1].config.root_dir
--   end
--   return vim.fn.getcwd()
-- end

return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	enabled = false,
	keys = {
		{
			"<leader>g",
			function()
				require("spectre").open()
			end,
			desc = "Replace (project)",
		},
		-- { "<leader>g", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Replace (file)" },
		-- { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, mode = { "n", "v" }, desc = "Replace word/selection" },
	},
	mapping = {
		["send_to_qf"] = {
			map = "<leader>q",
			cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
			desc = "send all items to quickfix",
		},
	},
	opts = {
		live_update = true,
		result_padding = " ",
		open_cmd = "vnew",
		color_devicons = true,
		line_sep_start = "┌----------------------------------------->",
		result_padding = "¦ ⋅  ⋅  ",
		line_sep = "└----------------------------------------->",
		lnum_for_results = false,
		highlight = {
			ui = "String",
			search = "DiffChange",
			replace = "DiffDelete",
		},
		use_trouble_qf = true,
		-- is_insert_mode = true,
		is_block_ui_break = true,
	},
}
