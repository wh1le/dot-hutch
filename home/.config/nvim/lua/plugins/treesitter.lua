local parsers = {
	"html",
	"toml",
	"bash",
	"gitcommit",
	"make",
	"ron",
	"json",
	"xml",
	"sql",
	"graphql",
	"ini",
	"diff",
	"gitignore",
	"gitattributes",
	"ssh_config",
	"regex",
	"rust",
	"c",
	"cpp",
	"java",
	"kotlin",
	"zig",
	"elixir",
	"ocaml",
	"hcl",
	"cmake",
	"ninja",
	"meson",
	"just",
	"tsv",
	"vim",
	"lua",
	"vimdoc",
	-- configuration
	"hyprlang",
	"nix",
	-- "tmux", # non existing
	-- generic
	"jq",
	"csv",
	-- operations
	"terraform",
	"dockerfile",
	"awk",
	"http",
	"passwd",
	-- config
	"yaml",
	-- docs: markdown
	"latex",
	"markdown",
	"markdown_inline",
	"mermaid",
	-- ruby
	"ruby",
	"embedded_template",
	"query",
	"go",
	-- Frontend
	"javascript",
	"typescript",
	"tsx",
	"css",
	"scss",
	"vue",
	"jsdoc",
	"qmljs",
	-- python
	"python",
	"requirements",
	"jinja",
	"prisma",
}

local no_ts_indent = { ruby = true, yaml = true, ["eruby.yaml"] = true }

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install(parsers)

		vim.treesitter.language.register("embedded_template", { "eruby", "erb" })
		vim.treesitter.language.register("yaml", "eruby.yaml")

		-- main branch has no module system: enable features per buffer via FileType
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("nm_treesitter", { clear = true }),
			callback = function(ev)
				local buf = ev.buf
				if vim.bo[buf].buftype ~= "" then
					return
				end
				local ft = vim.bo[buf].filetype

				-- highlighting (also loads the parser); bail if unavailable
				if not pcall(vim.treesitter.start, buf) then
					return
				end

				-- treesitter indentation
				if not no_ts_indent[ft] then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
