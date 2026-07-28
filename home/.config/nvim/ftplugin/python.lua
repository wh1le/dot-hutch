vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.g.python_recommended_style = 0
vim.opt_local.suffixesadd:append(".py")
vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
