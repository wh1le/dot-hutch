NM.lazy = {
	setup = function()
		NM.lazy._load_lazy_source()

		local spec = {
			{ import = "plugins" },
			{ import = "plugins.treesitter" },
		}

		table.insert(spec, { import = "plugins.lsp" })

		require("lazy").setup({
			spec = spec,
			install = {
				-- colorscheme = { "pywal16" }
			},
			change_detection = {
				enabled = true,
				notify = false,
			},
			ui = {
				backdrop = 100,
				border = "rounded",
				-- Use a light colorscheme for lazy UI
				custom_keys = {},
			},
			checker = { enabled = false },
		})
	end,

	_load_lazy_source = function()
		-- try nixos package first
		local lazy_path = vim.fn.expand("@lazy_nvim@")

		-- clone manually if not found
		if not (vim.uv or vim.loop).fs_stat(lazy_path) then
			lazy_path = vim.fn.expand("~/.local/share/nvim/lazy/lazy.nvim")

			if not (vim.uv or vim.loop).fs_stat(lazy_path) then
				NM.lazy._clone(lazy_path)
			end
		end

		vim.opt.rtp:prepend(lazy_path)
	end,

	_clone = function(lazy_path)
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazy_path })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end,
}
