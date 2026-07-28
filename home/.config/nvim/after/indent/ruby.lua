-- Runs after vim-ruby's indent/ruby.vim, so removals here actually stick.
-- These indentkeys reindent the current line mid-typing on each trigger char,
-- which makes the cursor "jump back one tab" while writing:
--   "." -> method chains / leading-dot continuations
--   ":" -> hashes, symbols, ternary
--   "e" -> bare letter retriggers (=end/=else/etc keep their word-match)
vim.opt_local.indentkeys:remove(".")
vim.opt_local.indentkeys:remove(":")
vim.opt_local.indentkeys:remove("e")
