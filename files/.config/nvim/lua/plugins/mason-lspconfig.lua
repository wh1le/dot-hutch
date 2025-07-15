return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },

	opts = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		return {
			ensured_installed = {
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
					local opts = {
						capabilities = capabilities,
					}

					require("lspconfig")[server].setup(opts)
				end,

				-- if server == "cspell-ls" then
				--   opts.init_options = {
				--     configFile = vim.fn.expand("~/.config/.cspell.json"),
				--   }
				--   opts.filetypes = { "*" }
				-- end

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
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
				end,
			},
		}
	end,

	-- opts = function()
	-- 	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	--
	-- 	return {
	-- 		ensured_installed = {
	-- 			-- Configs
	-- 			"bashls",
	-- 			"lua_ls",
	-- 			"jsonls",
	-- 			"yamlls",
	--
	-- 			-- Ruby
	-- 			"ruby_lsp",
	-- 			"rubocop",
	-- 			-- "reek",
	--
	-- 			-- JavaScript
	-- 			"eslint",
	-- 			"ts_ls",
	--
	-- 			-- Python
	-- 			"ruff",
	-- 			"pyright",
	-- 			"taplo",
	--
	-- 			"marksman",
	--
	-- 			-- Spelling
	-- 			-- "cspell_ls",
	-- 		},
	-- 		automatic_enable = true,
	-- 		handlers = {
	-- 			function(server)
	-- 				local opts = {
	-- 					capabilities = capabilities,
	-- 				}
	--
	-- 				require("lspconfig")[server].setup(opts)
	-- 			end,
	--
	-- 			-- if server == "cspell-ls" then
	-- 			--   opts.init_options = {
	-- 			--     configFile = vim.fn.expand("~/.config/.cspell.json"),
	-- 			--   }
	-- 			--   opts.filetypes = { "*" }
	-- 			-- end
	--
	-- 			["lua_ls"] = function()
	-- 				require("lspconfig").lua_ls.setup({
	-- 					capabilities = capabilities,
	-- 					settings = {
	-- 						Lua = {
	-- 							runtime = { version = "LuaJIT" },
	-- 							diagnostics = { globals = { "vim", "require" } },
	-- 							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
	-- 							telemetry = { enable = false },
	-- 						},
	-- 					},
	-- 				})
	-- 			end,
	-- 		},
	-- 	}
	-- end,
}
