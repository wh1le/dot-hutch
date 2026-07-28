NM = {}

vim.o.title = true
vim.o.titlestring = "nvim: %f"

require("helpers.lazy")
require("helpers.quit")

require("config.system_providers")
require("config.core")
require("config.bindings")
require("config.callbacks")
require("config.clipboard")
require("config.spell")
require("config.terminal")
require("config.ruby_rename")
require("config.vimgrep")

NM.lazy.setup()

vim.cmd("filetype plugin indent on")

vim.g.kitty_fast_forwarded_modifiers = true

vim.filetype.add({
	filename = {
		[".config/kanshi/config"] = "conf",
	},
	pattern = {
		[".*/%.config/kanshi/.*"] = "conf",
		[".*/tmux/tmux%.conf"] = "conf",
		["tmux%.conf"] = "conf",
		[".*"] = {
			function(path, bufnr)
				local content = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
				for _, line in ipairs(content) do
					if line:match("^%s*profile%s+") or line:match("^%s*output%s+") then
						return "kanshi"
					end
				end
			end,
			priority = -math.huge,
		},
	},
})

vim.filetype.add({
	extension = {
		coffee = "coffee",
		slim = "ruby.slim",
		haml = "ruby.haml",
	},
	pattern = {
		[".*_spec%.rb"] = { "ruby.spec" },
		[".*%.js%.jsx"] = "javascriptreact",
	},
})

-- TODO: migrate jest tests matching
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function(args)
--     local ft = vim.bo.filetype
--     if not ft:match("javascript") and not ft:match("typescript") then return end
--     if ft:match("jest") then return end
--
--     local file = args.file or vim.api.nvim_buf_get_name(0)
--
--     if file:match("(_spec|Spec|%-test|%.test)%.(js[x]?|ts[x]?)$") or
--        file:match("/__tests__/") or file:match("tests?/.*%.(js[x]?|ts[x]?)$") then
--       vim.cmd("noautocmd set filetype+=.jest")
--     end
--   end,
-- })

-- tree sitter is weirdo, doesn't support eruby
vim.treesitter.language.register("yaml", "eruby.yaml")

vim.o.showtabline = 1

-- Remove empty line ~ filler (annoying when vertical split)
vim.opt.fillchars:append({ eob = " " })
vim.opt.scrolloff = 0 -- helps centers the content of the page

vim.cmd([[au TermOpen * setlocal nospell]])
vim.opt.path:append("**")

-- asdf
-- vim.keymap.set("n", "<leader>b", ":ls<CR>:b ")
