vim.opt.grepprg = "rg --vimgrep -uu --smart-case"

vim.api.nvim_create_user_command("Grep", function(opts)
	vim.fn.setreg("/", opts.args)
	vim.cmd("silent grep! " .. opts.args)
	vim.cmd("copen")
end, { nargs = "+" })

vim.keymap.set("n", "<leader>g", ":Grep ", { desc = "Grep" })
vim.keymap.set("n", "]q", ":cnext <CR>", { desc = "Open next item in quickfix" })
vim.keymap.set("n", "[q", ":cprev <CR>", { desc = "Open previous item in quickfix" })
