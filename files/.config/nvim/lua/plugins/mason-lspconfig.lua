return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local function default(server)
			require("lspconfig")[server].setup({ capabilities = capabilities })
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "require" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("ruby_lsp", {
			capabilities = capabilities,
			cmd = { "bundle", "exec", "ruby-lsp" },
		})

		require("mason-lspconfig").setup({
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
        "typos_lsp",
        "ltex",
			},
			automatic_enable = true, -- default is already true, but explicit is fine
		})
	end,
}
