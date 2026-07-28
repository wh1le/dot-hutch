-- example for "=" use: :EasyAlign =
-- -> :'<,'>EasyAlign =  " first =
-- -> :'<,'>EasyAlign *= " all =
-- -> :'<,'>EasyAlign -= " last =
--
-- example for comments: :EasyAlign #
-- -> :'<,'>EasyAlign #          " align end-of-line comments
--
-- example for whitespace: :EasyAlign \
-- -> :'<,'>EasyAlign \          " first whitespace
-- -> :'<,'>EasyAlign 2\         " 2nd whitespace
--
-- example for regex: :EasyAlign /pattern/
-- -> :'<,'>EasyAlign /from/     " align on "from"
-- -> :'<,'>EasyAlign /=>/       " align on =>
-- -> :'<,'>EasyAlign /desc/     " align on "desc"

return {
	"junegunn/vim-easy-align",
	cmd = { "EasyAlign", "Align" },
	init = function()
		vim.cmd("cnoreabbrev Align EasyAlign")
	end,
}
