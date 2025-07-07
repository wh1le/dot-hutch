-- Set leader key
vim.g.mapleader = ","

-- Navigation and movement
vim.keymap.set('', 'j', 'gj')
vim.keymap.set('', 'k', 'gk')
vim.keymap.set('', '<Space>', '/')
vim.keymap.set('', '<C-Space>', '?')
vim.keymap.set('n', '<leader><CR>', ':noh<CR>', { silent = true })

-- Buffers
vim.keymap.set('n', '<leader>bd', ':Bclose<CR>:tabclose<CR>gT')
vim.keymap.set('n', '<leader>ba', ':bufdo bd<CR>')
vim.keymap.set('n', '<leader>l', ':bnext<CR>')
vim.keymap.set('n', '<leader>h', ':bprevious<CR>')

-- Tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>')
vim.keymap.set('n', '<leader>to', ':tabonly<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')
vim.keymap.set('n', '<leader>tm', ':tabmove ')
vim.keymap.set('n', '<leader>t<leader>', ':tabnext<CR>')

vim.g.lasttab = 1
vim.keymap.set('n', '<leader>tl', ':exe "tabn " .. vim.g.lasttab<CR>')
vim.api.nvim_create_autocmd('TabLeave', {
  pattern = '*',
  command = 'let g:lasttab = tabpagenr()'
})

-- File helpers
vim.keymap.set('n', '<leader>te', ':tabedit %:p:h<CR>/')
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

-- Editing
vim.keymap.set('', '0', '^')
vim.keymap.set('n', '<M-j>', 'mz:m+<CR>`z')
vim.keymap.set('n', '<M-k>', 'mz:m-2<CR>`z')
vim.keymap.set('v', '<M-j>', ":m'>+<CR>`<my`>mzgv`yo`z")
vim.keymap.set('v', '<M-k>', ":m'<-2<CR>`>my`<mzgv`yo`z")
vim.keymap.set('n', '<D-j>', '<M-j>')
vim.keymap.set('n', '<D-k>', '<M-k>')
vim.keymap.set('v', '<D-j>', '<M-j>')
vim.keymap.set('v', '<D-k>', '<M-k>')

-- Visual replace
vim.keymap.set('v', '<leader>r', ':<C-u>call VisualSelection("replace", "")<CR>', { silent = true })

-- Quickfix
vim.keymap.set('n', '<leader>cc', ':botright cope<CR>')
vim.keymap.set('n', '<leader>co', 'ggVGy:tabnew<CR>:set syntax=qf<CR>pgg')
vim.keymap.set('n', '<leader>n', ':cn<CR>')
vim.keymap.set('n', '<leader>p', ':cp<CR>')

-- Spelling
vim.keymap.set('n', '<leader>sn', ']s')
vim.keymap.set('n', '<leader>sp', '[s')
vim.keymap.set('n', '<leader>sa', 'zg')
vim.keymap.set('n', '<leader>s?', 'z=')

-- Remove ^M characters
vim.keymap.set('n', '<leader>m', "mmHmt:%s/\\r//ge<CR>'tzt'm", { noremap = true })

-- Scratch buffers
vim.keymap.set('n', '<leader>q', ':e ~/buffer<CR>')
vim.keymap.set('n', '<leader>x', ':e ~/buffer.md<CR>')

-- Toggle paste mode
vim.keymap.set('n', '<leader>pp', ':setlocal paste!<CR>')

-- Smart window nav
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-l>', '<C-W>l')

-- Shared clipboard buffer file
vim.keymap.set('v', '<leader>y', ':w! ~/.vbuf<CR>')
vim.keymap.set('n', '<leader>y', ':.w! ~/.vbuf<CR>')
-- vim.keymap.set('n', '<leader>r', ':r ~/.vbuf<CR>') -- optional paste from buffer file

-- Vim-test mappings
vim.keymap.set('n', '<leader>r', ':TestLast<CR>', { silent = true })
vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { silent = true })
vim.keymap.set('n', '<leader>s', ':TestNearest<CR>', { silent = true })
vim.keymap.set('n', '<leader>t', ':TestFile<CR>', { silent = true })

-- Buffer nav
vim.keymap.set('n', '<leader>p', ':bp<CR>')
vim.keymap.set('n', '<leader>n', ':bn<CR>')
vim.keymap.set('n', '<leader>d', ':bd<CR>')

-- Vimwiki
vim.keymap.set('n', '<leader>tt', '<Plug>VimwikiToggleListItem')
vim.keymap.set('n', '<leader>wf', '<Plug>VimwikiFollowLink')
vim.keymap.set('n', '<leader>wq', '<Plug>VimwikiVSplitLink')

-- copy to clipboard (normal + visual)
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], {
  noremap = true,
  silent  = true,
  desc    = 'Yank to system clipboard',
})
--
-- vim.g.clipboard = {
--   name = "win32yank-wsl",
--   copy  = {["+"] = "win32yank.exe -i --crlf",
--            ["*"] = "win32yank.exe -i --crlf"},
--   paste = {["+"] = "win32yank.exe -o --lf",
--            ["*"] = "win32yank.exe -o --lf"},
--   cache_enabled = true,
-- }
