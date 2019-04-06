call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mhinz/vim-signify'

" Plug 'w0rp/ale'
call plug#end()

colorscheme desert

set softtabstop=2
set shiftwidth=2
set hidden
set autowrite
let mapleader = ' '
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

if executable('rg')
  set grepprg=rg\ --color=never
end
inoremap jj <Esc>


" Return to last edit position when opening files (You want this!)
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


" Signify config: highlight vcs changes
let g:signify_vcs_list = ['git']

