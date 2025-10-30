-- TODO: Needs configuration and packages installed in nix config
return {
	"iamcco/markdown-preview.nvim",
	enabled = false,
	build = "cd app && npx --yes yarn install",
	ft = { "markdown" },
	init = function()
		vim.g.mkdp_port = "1111"
	end,
}
