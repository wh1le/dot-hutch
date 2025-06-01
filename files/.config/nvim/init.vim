call plug#begin()
  Plug 'https://github.com/chriskempson/base16-vim.git'
  Plug 'https://github.com/morhetz/gruvbox.git'
  Plug 'https://github.com/cocopon/iceberg.vim.git'
  Plug 'https://github.com/tpope/vim-fugitive.git'
  Plug 'https://github.com/rhysd/vim-color-spring-night.git'
  Plug 'git://github.com/Yggdroot/indentLine.git'
  Plug 'https://github.com/vimwiki/vimwiki.git'

  Plug 'git://github.com/tpope/vim-surround.git'
  Plug 'git://github.com/tpope/vim-endwise.git'
  Plug 'tomtom/tcomment_vim'

  Plug 'https://github.com/janko/vim-test.git', { 'for': ['ruby', 'ruby.spec'] }
  Plug 'https://github.com/tpope/vim-rails.git'

  " Hightliting
  Plug 'https://github.com/HerringtonDarkholme/yats.vim.git' " Typescript
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'maxmellon/vim-jsx-pretty', { 'for': 'javascript' }
  Plug 'slim-template/vim-slim'

  Plug 'scrooloose/nerdtree'
  Plug '/usr/local/opt/fzf'
  Plug 'dyng/ctrlsf.vim'
  Plug 'universal-ctags/ctags'
  Plug 'jiangmiao/auto-pairs'

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'https://github.com/jpalardy/vim-slime'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'git@github.com:jeetsukumaran/vim-buffergator.git'
call plug#end()

let g:perl_host_prog = '/usr/local/bin/perl'
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}

syntax sync fromstart

source ~/.config/nvim/core.vim
source ~/.config/nvim/hotkeys.vim

let g:UltiSnipsExpandTrigger="<c-j>"

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" set t_Co=256
set termguicolors
" colorscheme iceberg
colorscheme base16-gruvbox-dark-soft

highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
highlight NonText ctermbg=none

hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=none gui=NONE guifg=DarkGrey guibg=NONE
hi StatusLine ctermfg=DarkBlue
" hi Directory guifg=#FF0000 ctermfg=5

set nowrap
set linebreak

" Commented because of the vim typescript issues
" set regexpengine=1
" set ttyfast
" set nolazyredraw

" Disable statusline in nerdtree
augroup filetype_nerdtree
    au!
    au FileType nerdtree call s:disable_lightline_on_nerdtree()
    au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_nerdtree()
augroup END

fu s:disable_lightline_on_nerdtree() abort
    let nerdtree_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'nerdtree') + 1
    call timer_start(0, {-> nerdtree_winnr && setwinvar(nerdtree_winnr, '&stl', '%#Normal#')})
endfu

let $TERM="tmux-256color"

vmap <C-c> "+y

au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

let g:buffergator_viewport_split_policy="B"
let g:buffergator_split_size="10"
let g:buffergator_display_regime="bufname"


lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig').pylsp.setup{
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {'W391'},
            maxLineLength = 100
          }
        }
      }
    }
  }
EOF


" Highlight Function names.  From
" http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim/773392#773392

syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen

hi def link cCustomFunc  Function

hi Function term=italic gui=italic

hi LineNr   term=bold ctermfg=Blue gui=bold guifg=Blue
hi LineNrBelow   term=italic ctermfg=Gray gui=italic guifg=Gray
hi LineNrAbove   term=italic ctermfg=Gray gui=italic guifg=Gray
set number relativenumber