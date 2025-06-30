-- TComment: Disable all default mappings except the operator
vim.g.tcomment_mapleader1 = ''
vim.g.tcomment_mapleader2 = ''
vim.g.tcomment_mapleader_comment_anyway = ''
vim.g.tcomment_textobject_inlinecomment = ''
vim.g.tcomment_mapleader_uncomment_anyway = 'gu' -- better than default g<

-- indentLine config
-- vim.g.indentLine_char_list = { '¦', '┊' } -- optional alt
vim.g.indentLine_char_list = { '·' }
vim.g.indentLine_enabled = 1
