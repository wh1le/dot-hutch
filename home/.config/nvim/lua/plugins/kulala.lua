-- https://neovim.getkulala.net/docs/getting-started/configuration-options/

return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "Send request" },
		{ "<leader>Ra", desc = "Send all requests" },
		{ "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = true,
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
		default_view = "body",
		split_direction = "vertical",
		contenttypes = {
			["application/json"] = {
				ft = "json",
				formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
				pathresolver = function(...)
					return require("kulala.parser.jsonpath").parse(...)
				end,
			},
			["application/graphql"] = {
				ft = "graphql",
				formatter = vim.fn.executable("prettier") == 1
					and { "prettier", "--stdin-filepath", "graphql", "--parser", "graphql" },
				pathresolver = nil,
			},
			["application/xml"] = {
				ft = "xml",
				formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
				pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
			},
			["text/html"] = {
				ft = "html",
				formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "--html", "-" },
				pathresolver = nil,
			},
		},

		ui = {
			default_view = "body",
			icons = {
				inlay = {
					loading = "⏳",
					done = "✅",
					error = "❌",
				},
			},
		},
	},
}
