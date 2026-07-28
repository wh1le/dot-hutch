-- Plugins
--
-- UI
--   alpha-nvim:              dashboard/startup screen
--   lualine.nvim:            statusline
--   indent-blankline.nvim:   indentation guides
--   nvim-tree.lua:           file tree explorer
--   oil.nvim:                edit filesystem like a buffer
--   statuscol.nvim:          customizable status column
--   fidget.nvim:             LSP progress notifications
--   aerial.nvim:             code outline/symbol navigator
--
-- Themes
--   base16-vim:              base16 color scheme support
--   vim-noctu:               noctu terminal colorscheme
--   pywal16.nvim:            pywal color integration
--   nvim-highlight-colors:   inline color preview (hex/rgb)
--
-- Git
--   diffview.nvim:           diff viewer for changed files
--   vim-grepper:             grep wrapper (multiple backends)
--   fzf-lua:                 fuzzy finder (fzf backend)
--
-- LSP
--   nvim-lspconfig:          language server configuration
--   lspsaga.nvim:            enhanced LSP UI (actions, defs, outline)
--   conform.nvim:            code formatter
--   mason.nvim:              language server installer
--   trouble.nvim:            diagnostics/quickfix viewer (disabled?)
--
-- Treesitter
--   nvim-treesitter:         syntax highlighting/code structure
--   treesitter-context:      shows code context at top of viewport
--   treesitter-textobjects:  navigation via treesitter nodes
--
-- Completion
--   nvim-cmp:                completion engine + sources
--   LuaSnip:                 snippet engine
--   friendly-snippets:       snippet collection
--   lspkind.nvim:            completion menu icons
--
-- Editing
--   nvim-autopairs:          auto-close brackets/quotes
--   vim-surround:            surround text objects
--   tcomment_vim:            comment/uncomment with motions
--   vim-easy-align:          text alignment (:EasyAlign / :Align)
--
-- Navigation
--   smart-splits.nvim:       split navigation and resizing
--   neoscroll.nvim:          smooth scrolling
--   faster.nvim:             faster motions/operations
--
-- Language
--   vim-rails:               rails integration
--   vim-slime:               send code to tmux/screen REPL
--   vim-projectionist:       project navigation/alternate files
--
-- Tools
--   claude-code.nvim:        Claude AI assistant
--   nvim-bqf:                better quickfix list
--   nvim-web-devicons:       file type icons
--   mini.icons:              icon provider
--   plenary.nvim:            lua utility library

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
