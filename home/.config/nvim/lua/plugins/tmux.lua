return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	opts = {
		at_edge = "stop",
	},
	keys = {
		{ "<C-h>", function() require("smart-splits").move_cursor_left() end },
		{ "<C-l>", function() require("smart-splits").move_cursor_right() end },
		{ "<C-k>", function() require("smart-splits").move_cursor_up() end },
		{ "<C-j>", function() require("smart-splits").move_cursor_down() end },
		{ "<M-h>", function() require("smart-splits").resize_left() end },
		{ "<M-j>", function() require("smart-splits").resize_down() end },
		{ "<M-k>", function() require("smart-splits").resize_up() end },
		{ "<M-l>", function() require("smart-splits").resize_right() end },
	},
}
