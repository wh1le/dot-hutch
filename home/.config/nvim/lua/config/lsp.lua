vim.lsp.config("*", {
	capabilities = vim.tbl_deep_extend("force", require("cmp_nvim_lsp").default_capabilities(), {
		general = { positionEncodings = { "utf-16" } },
	}),
})

local lsp_path = vim.fn.stdpath("config") .. "/lua/config/lsp"

for _, file in ipairs(vim.fn.readdir(lsp_path) or {}) do
	if file:match("%.lua$") and file ~= "init.lua" then
		local module = "config.lsp." .. file:gsub("%.lua$", "")

		local ok, _ = pcall(require, module)
		if not ok then
			vim.notify("Failed to load: " .. module, vim.log.levels.WARN)
		end
	end
end
