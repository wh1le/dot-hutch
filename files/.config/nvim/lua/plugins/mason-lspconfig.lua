return {
	"williamboman/mason-lspconfig.nvim",
	-- lazy = true,
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = {
			-- Configs
			"bashls",
			"lua_ls",
			"jsonls",
			"yamlls",

			-- Ruby
			"ruby_lsp",
			"rubocop",
			-- "reek",

			-- JavaScript
			"eslint",
			"ts_ls",

			-- Python
			"ruff",
			"pyright",
			"taplo",

			"marksman",

			-- Spelling
			-- "cspell_ls",
		},
		automatic_enable = true,
		handlers = {
			function(server)
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				local opts = {
					capabilities = capabilities,
				}

				-- if server == "cspell-ls" then
				--   opts.init_options = {
				--     configFile = vim.fn.expand("~/.config/.cspell.json"),
				--   }
				--   opts.filetypes = { "*" }
				-- end

				require("lspconfig")[server].setup(opts)
			end,
		},
	},
}
