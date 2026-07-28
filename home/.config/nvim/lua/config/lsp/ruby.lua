local ruby_root_markers = {
	"Gemfile",
	"Rakefile",
	".rubocop.yml",
	".git",
}

vim.lsp.config.ruby_lsp = {
	cmd = { "bundle", "exec", "ruby-lsp" },
	filetypes = { "ruby", "spec", "ruby.spec", "rake" },
	root_markers = ruby_root_markers,
	single_file_support = true,
}

vim.lsp.config.rubocop = {
	cmd = { "bundle", "exec", "rubocop", "--lsp" },
	filetypes = { "ruby", "spec", "ruby.spec", "rake" },
	root_markers = ruby_root_markers,
}

vim.lsp.config.solargraph = {
	cmd = { "bundle", "exec", "solargraph", "stdio" },
	filetypes = { "ruby", "spec", "ruby.spec", "rake" },
	root_markers = ruby_root_markers,
	single_file_support = true,

	-- Keep solargraph's special overrides
	capabilities = {
		textDocument = {
			definition = { dynamicRegistration = false },
		},
	},
	settings = {
		solargraph = {
			diagnostics = false,
			formatting = false,
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.definitionProvider = false
		client.server_capabilities.referencesProvider = false
		client.server_capabilities.workspaceSymbolProvider = false
	end,
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "ruby", "spec", "ruby.spec", "rake" },
	once = true,
	callback = function()
		local bundles = { "ruby-lsp", "solargraph", "rubocop" }
		for _, gem in ipairs(bundles) do
			vim.system({ "bundle", "show", gem }, {}, function(obj)
				if obj.code == 0 then
					vim.schedule(function()
						vim.lsp.enable(gem == "ruby-lsp" and "ruby_lsp" or gem)
					end)
				end
			end)
		end
	end,
})
