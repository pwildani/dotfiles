"github.com/junegunn/vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

" Fast Search
Plug 'ctrlpvim/ctrlp.vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mhinz/vim-signify'
Plug 'thinca/vim-editvar'
"Plug 'zxqfl/tabnine-vim'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

Plug 'jceb/vim-orgmode', {'for': 'org'}
"orgmode deps
  " Universal text linking"
  "Plug 'vim-scripts/utl'
  Plug 'inkarkat/vim-SyntaxRange'

Plug 'majutsushi/tagbar'

" Bunch of text objects.
" target modifier: default: current n: next l: last
" pairs: () {} [] B t b (any block)
" quotes: ' " ` q (any quote)
" separator: ,.;:+-=~_*#/|\&$
" argument: a
Plug 'wellle/targets.vim'

" Surrounding editor
" Add: sa <motion> <surrounding>
" Remove: sd
" Replace: sr
Plug 'machakann/vim-sandwich'

" Plug 'w0rp/ale'
call plug#end()

colorscheme desert

set softtabstop=2
set shiftwidth=2
set hidden
set autowrite
let mapleader = ' '
let maplocalleader = ','
set wildmenu
set wildmode=longest:full,full
set encoding=utf8
set incsearch
set ignorecase
set smartcase
set lazyredraw
set expandtab
set smarttab
set nowrap
set showmatch
nnoremap <silent> <CR> :nohlsearch<CR><CR>

set ruler

" pip2 install neovim --upgrade
" pip3 install neovim --upgrade
let g:python2_host_prog = '/usr/local/bin/python' 
let g:python3_host_prog = '/usr/local/bin/python3'

if executable('rg')
  set grepprg=rg\ --color=never
end
inoremap jj <Esc>


" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END



" CtrlP Config
noremap <Leader>f :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ }
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
end
let g:ctrlp_switch_buffer = 0

" ALE config (linter, language server integration
let g:ale_completion_enabled = 1
let g:ale_fixers = {
 \  '*': ['remove_trailing_lines', 'trim_whitespace'],
 \  'rs': ['rustfmt'],
 \}

" NERDTree config
nmap <silent> <leader>F <ESC>:NERDTreeToggle<CR>
"

"LanguageServer config
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
\}
function! LC_buffer_config()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <Leader>5 :call LanguageClient_contextMenu()<CR>
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    "nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    "" Default gR is "enter screen-wise replace mode". Not useful.
    nnoremap <buffer> <silent> gR :call LanguageClient#textDocument_rename()<CR>

    setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  end
endfunction

augroup LanguageClientSetup
   autocmd FileType * call LC_buffer_config()
augroup END

" It attempts to render any sign text after the source code, but doesn't trim
" or wrap well, corrupting the display
let g:LanguageClient_hoverPreview = 'Always'

" The default signage uses double width emoji, which doesn't render well
let g:LanguageClient_diagnosticsDisplay = {
  \     1: {
  \         "name": "Error",
  \         "texthl": "ALEError",
  \         "signText": "X",
  \         "signTexthl": "ALEErrorSign",
  \         "virtualTexthl": "Error",
  \     },
  \     2: {
  \         "name": "Warning",
  \         "texthl": "ALEWarning",
  \         "signText": "W",
  \         "signTexthl": "ALEWarningSign",
  \         "virtualTexthl": "Todo",
  \     },
  \     3: {
  \         "name": "Information",
  \         "texthl": "ALEInfo",
  \         "signText": "ℹ",
  \         "signTexthl": "ALEInfoSign",
  \         "virtualTexthl": "Todo",
  \     },
  \     4: {
  \         "name": "Hint",
  \         "texthl": "ALEInfo",
  \         "signText": "",
  \         "signTexthl": "ALEInfoSign",
  \         "virtualTexthl": "Todo",
  \     },
  \ }


" Signify config: highlight vcs changes
let g:signify_vcs_list = ['git']

"orgmode config:
let g:org_heading_shade_leading_stars=1
let g:org_indent=1


nnoremap <F8> :TagbarToggle<CR>
