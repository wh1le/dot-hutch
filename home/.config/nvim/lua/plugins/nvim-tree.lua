return {
	"nvim-tree/nvim-tree.lua",
	-- lazy = false,
	opts = {
		sync_root_with_cwd = true,
		hijack_netrw = false,
		actions = {
			change_dir = {
				enable = true, -- run :cd or :tcd every time the tree’s root changes
				global = true, -- true  → :cd (changes cwd for *all* tabs)
				-- false → :tcd (tab-local cwd)     :contentReference[oaicite:2]{index=2}
			},
		},
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 30,
			side = "right",
			adaptive_size = true,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = false, -- false == show dotfiles
		},
	},
	keys = {
		{
			",,",
			function()
				require("nvim-tree.api").tree.toggle()
			end,
			desc = "Toggle NvimTree",
		},
		{
			"<leader>e",
			function()
				require("nvim-tree.api").tree.open({
					find_file = true, -- reveal the file under the cursor
					focus = true, -- jump cursor into the tree
					update_root = true, -- (optional) set tree root to that directory
				})
			end,
			desc = "NvimTree › reveal current file",
			mode = "n",
		},
		{
			"<C-s>",
			function()
				require("nvim-tree.api").node.open.horizontal()
			end,
			desc = "NvimTree › horizontal split",
			mode = "n",
			buffer = function()
				return vim.bo.filetype == "NvimTree"
			end, -- limit to tree buffer
		},
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		-- 🧵 BOLD FOLDERS
		local hl = vim.api.nvim_set_hl
		hl(0, "NvimTreeFolderName", { bold = true }) -- folder text
		hl(0, "NvimTreeOpenedFolderName", { bold = true }) -- opened folder text
		hl(0, "NvimTreeFolderIcon", { bold = true }) -- folder icon
	end,
}
