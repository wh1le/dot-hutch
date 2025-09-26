return {
	"stevearc/oil.nvim",
	opts = {
    use_default_keymaps = false,
    view_options = { show_hidden = true },
    default_file_explorer = true,
    keymaps = {
      ["<CR>"] = "actions.select",
      ["-"] = { "actions.parent", mode = "n" },
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
    },
  },

  keys = {
    { "-", function() require("oil").open() end, desc = "Oil: Open parent dir", mode = "n", silent = true },
    { "<leader><leader>", function() require("oil").open() end, desc = "Oil: Open parent dir", mode = "n", silent = true },
  },

	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lazy", "lazyterm", "aerial" },
			callback = function() vim.keymap.set("n", "-", "<nop>", { buffer = true }) end,
		})
	end,
}
