return {
	"williamboman/mason-lspconfig.nvim",
  enabled = true,
	dependencies = { "williamboman/mason.nvim" },
	opts = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, {
			offsetEncoding = { "utf-16" },
			general = {
				positionEncodings = { "utf-16" },
			},
		})

		capabilities.textDocument.signatureHelp = {
			dynamicRegistration = false,
			signatureInformation = {
				documentationFormat = { "markdown", "plaintext" },
				parameterInformation = { labelOffsetSupport = true },
			},
		}

    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

		capabilities.textDocument.documentOnTypeFormatting = {
			firstTriggerCharacter = "\n", -- usually newline or `}`
		}

		local function default(server)
			require("lspconfig")[server].setup({ capabilities = capabilities })
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "require" } },
					workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true) 
          },
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("ruby_lsp", {
			capabilities = capabilities,
			cmd = { "rbenv", "exec", "ruby-lsp" },
		})
 
		vim.lsp.config("ruff", {
			capabilities = capabilities,
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
        "nil_ls",

        -- Spelling
        "typos_lsp",
        -- "ltex",
			},
			automatic_enable = true, -- default is already true, but explicit is fine
		})
	end,
}
