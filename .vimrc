" a lot was borrowed from
" [https://github.com/theopn/kickstart.vim/blob/main/.vimrc]

"""""""""""""""
"" Vim specific
"""""""""""""""
let mapleader=' '
let maplocalleader='\'
set nocompatible "forget vi
set path+=** "
set wildmenu " when on, allows tab completion and suggestions
set wildoptions=pum,tagfile

command! MakeTags !ctags -R .

let g:netrw_banner=0
let g:netrw_browse_split=4 "open in prior window
let g:netrw_altv=1 "open splits to the right
let g:netrw_liststyle=3 "tree view

set shell=/usr/bin/zsh
set hidden " don't unload a buffer when no longer shown in a window (allow opening other files w/o saving current buffer)
set backspace=indent,eol,start belloff=all " more powerful backspace
set history=10000 "how many commands are remembered
set display=lastline "include 'lastline' to show the last line
set encoding=utf-8 " character encoding used in Vim
set hlsearch " highlight all matches for a last used search pattern
" pressing Esc in normal mode removes highlight search:
nnoremap <Esc> :nohlsearch<CR> 
set showcmd " show command as you type it
set switchbuf=uselast " which window to use when jumping to a buffer

set mouse=a " enable mouselet 
set clipboard=unnamedplus " sync with system clipboard
set breakindent " enabled break indent

set ignorecase
set smartcase

set updatetime=250 " decrease update time
set timeoutlen=300 " show which-key sooner

set splitright
set splitbelow " configure how splits appear

set signcolumn=yes " allows something like git-gutter to work
" set cursorline " highlights the entire line you are on
set scrolloff=5 " minimum number of screen lines to keep above and below cursor

" Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
" for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
" is not what someone will guess without a bit more experience.
"
" NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
" or just use <C-\><C-n> to exit terminal mode
tnoremap <Esc><Esc> <C-\><C-n>

" Remap for dealing with word wrap
nnoremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'

" Undo: keep undo history across sessions.
set undofile
set undodir=~/.vim/undodir

" Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Splits
" Split window vertically (new window on the right)
nnoremap <leader>\| :vsplit<CR>
" Split window horizontally (new window below)
nnoremap <leader>_ :split<CR>

" Better search: use incremental search + highlight current match.
set incsearch
set hlsearch
set showmatch

"""""""""""""""
"" Appearance
"""""""""""""""

set laststatus=2 " always show file name in status bar. Set to 1 to only do this when working on multiple buffers

set t_Co=256 " 256 colors in vim

" The following changes the cursor during insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

set textwidth=80 " wrap existing block of text to 80 char. use gqq or gww to wrap

set number relativenumber " hybrid relative numbers on left-side

"""""""""""""""
"" Coding
"""""""""""""""

set shiftwidth=2 "indent 4 spaces not 8
set softtabstop=2
set expandtab
set smarttab " inserts 'shiftweidth' spaces
set noswapfile

syntax on " syntax highlighting
filetype on " enable filetype detection
set autoindent autoread " autoindent, and automatically change file if it has been altered outside vim

"""""""""""""""
"" Plugins
"""""""""""""""

filetype plugin indent on " allow plugins

call plug#begin()
Plug 'tpope/vim-unimpaired' " There are mappings which are simply short normal mode aliases for commonly used ex commands. ]q is :cnext. [q is :cprevious. ]a is :next. [b is :bprevio
Plug 'tpope/vim-surround' " surround; default is shift-s I believe
Plug 'tpope/vim-repeat' " extends the . repeat command to plugin maps
Plug 'tpope/vim-sleuth' " detect tabstop and shiftwidth auto
Plug 'tpope/vim-commentary' " comment lines with gcc
" Plug 'tpope/vim-sensible' " sensible defaults
Plug 'preservim/NERDTree' " filetree explorer
Plug 'godlygeek/tabular' " align text
Plug 'lervag/vimtex' " Latex editing
" helpful guide for key mappings:
Plug 'liuchengxu/vim-which-key' ", { 'on': ['WhichKey', 'WhichKey!'] } 
Plug 'catppuccin/vim', { 'as': 'catppuccin' } " theme
Plug 'machakann/vim-highlightedyank' " highlights yanks
Plug 'markonm/traces.vim' " realtime substitution
Plug 'airblade/vim-gitgutter' " adds git realted signs to the gutter
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fuzzy find
Plug 'junegunn/fzf.vim'
" Install language servers and configure them for vim-lsp
Plug 'mattn/vim-lsp-settings'
" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Enable LSP
Plug 'prabirshrestha/vim-lsp'
" Use <Tab> to auto complete
Plug 'ervandew/supertab'
" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'itchyny/lightline.vim' " status line
Plug 'christoomey/vim-tmux-navigator' " tmux navigator (C-j,k,h,l)
Plug 'vifm/vifm.vim' "vifm file manager
call plug#end()

"""""""""""""""
"" Plugin Specific
"""""""""""""""

""" Tabular
"" Auto indent when making a markdown style table
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

""" Vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexrun'

""" Whickey
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '\'<CR>
" Document existing key chains
let g:which_key_map =  {}
let g:which_key_map.b = { 'name' : '[B]uffer' }
let g:which_key_map.c = { 'name' : '[C]ode' }
let g:which_key_map.d = { 'name' : '[D]ocument' }
let g:which_key_map.r = { 'name' : '[R]ename' }
let g:which_key_map.s = { 'name' : '[S]earch' }
let g:which_key_map.w = { 'name' : '[W]orkspace' }
let g:which_key_map.t = { 'name' : '[T]oggle' }
let g:which_key_map.h = { 'name' : 'Git [H]unk' }

""" Catpuccin
set termguicolors
colorscheme catppuccin_mocha

""" highlightedyank
let g:highlightedyank_highlight_duration = 100

""" fzf
nmap <leader>sh :Helptags<CR>
let g:which_key_map.s.h = '[S]earch [H]elp'
nmap <leader>sk :Maps<CR>
let g:which_key_map.s.k = '[S]earch [K]eymaps'
nmap <leader>sf :Files<CR>
let g:which_key_map.s.f = '[S]earch [F]iles'
nmap <leader>sg :Rg<CR>
let g:which_key_map.s.g = '[S]earch by [G]rep'
nmap <leader>s. :History<CR>
let g:which_key_map.s['.'] = '[S]earch Recent Files ("." for repeat)'
nmap <leader><leader> :Buffers<CR>
let g:which_key_map[' '] = '[ ] Find existing buffers'
nmap <leader>/ :BLines<CR>
let g:which_key_map['/'] = '[/] Fuzzily search in current buffer'

nmap <leader>bd :bd<CR>
let g:which_key_map.b.d = '[B]uffer [D]delete'
nmap <leader>e :NERDTreeToggle<CR>
let g:which_key_map['e'] = '[e] Open NERDTree'

""" lsp
" Performance related settings, requires Vim 8.2+
let g:lsp_use_native_client = 1
let g:lsp_semantic_enabled = 0
let g:lsp_format_sync_timeout = 1000

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  " Keymaps
  " Go to previous diagnostic message
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  " Go to next diagnostic message
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)

  nmap <buffer> <leader>rn <plug>(lsp-rename)
  let g:which_key_map.r.n = '[R]e[n]ame'
  nmap <buffer> <leader>ca <plug>(lsp-code-action-float)
  let g:which_key_map.c.a = '[C]ode [A]ction'

  " [G]oto [D]efinition
  nmap <buffer> gd <plug>(lsp-definition)
  " [G]oto [R]eferences
  nmap <buffer> gr <plug>(lsp-references)
  " [G]oto [I]mplementation
  nmap <buffer> gI <plug>(lsp-implementation)

  nmap <buffer> <leader>D <plug>(lsp-peek-type-definition)
  let g:which_key_map.D = 'Type [D]efinition'
  nmap <buffer> <leader>ds <plug>(lsp-document-symbol-search)
  let g:which_key_map.d.s = '[D]ocument [S]ymbols'
  nmap <buffer> <leader>ws <plug>(lsp-workspace-symbol-search)
  let g:which_key_map.w.s = '[W]orkspace [S]ymbols'

  " See `:help K` for why this keymap
  " Hover Documentation
  nmap <buffer> K <plug>(lsp-hover)
  " Signature Documentation
  nmap <buffer> <C-k> <plug>(lsp-signature-help)

  " Lesser used LSP functionality
  " [G]oto [D]eclaration
  nmap <buffer> gD <plug>(lsp-declaration)

  " Create a command `:Format` local to the LSP buffer
  command Format LspDocumentFormatSync
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

""" omni completion
set omnifunc=syntaxcomplete#Complete

" Enter key confirms the current selection when completion is open
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'

" <Tab> triggers Omni completion (<C-x><C-o>) in a coding context
let g:SuperTabDefaultCompletionType = "context"

""" LSP Setups
" Python
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

let g:lightline = {
      \ 'colorscheme': 'material',
      \ }

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" Vifm
let g:vifm_embed_term=1
let g:vifm_embed_split=1
