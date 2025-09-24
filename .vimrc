"
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
"
" Make sure you use single quotes

" Line number
set number

let g:gutentags_enabled = 0
let g:formatdef_clangformat = '"clang-format --style=Google"'
let g:formatters_cpp = ['clangformat']
let g:formatters_c   = ['clangformat']

call plug#begin('~/.vim/plugged')

" Core plugins
" Shorthand notation for GitHub; translates to https://github.com/junegunn/seoul256.vim.git
Plug 'junegunn/seoul256.vim'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-easy-align.git'

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Using a non-default branch
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Use 'dir' option to install plugin in a non-default directory
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }

" Post-update hook: run a shell command after installing or updating the plugin
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Post-update hook can be a lambda expression
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" If the vim plugin is in a subdirectory, use 'rtp' option to specify its path
Plug 'nsf/gocode', { 'rtp': 'vim' }

" On-demand loading: loaded when the specified command is executed
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'ryanoasis/vim-devicons'                " icons

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'  " ← correct repo name


" On-demand loading: loaded when a file with a specific file type is opened
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'


" Add cmake4vim plugin
Plug 'ilyachur/cmake4vim'

" Add markdown preview
" --- C++ Plugins ---
Plug 'https://github.com/bfrg/vim-c-cpp-modern.git'  " official repo as per installation guide
Plug 'andymass/vim-matchup'
Plug 'dense-analysis/ale'
Plug 'Chiel92/vim-autoformat'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
" --- Markdown Plugins ---
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'masukomi/vim-markdown-folding'  " correct source for vim-markdown-folding
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install', 'for': 'markdown' }
Plug 'dhruvasagar/vim-table-mode'
Plug 'mzlogin/vim-markdown-toc', { 'do': 'make install' }
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'

call plug#end()

set encoding=utf-8
let g:webdevicons_enable = 1
" Color schemes should be loaded after plug#end().
" We prepend it with 'silent!' to ignore errors when it's not yet installed.
silent! colorscheme seoul256

" --- Gutentags Configuration ---
" Ensure 'ctags' executable is installed so Gutentags can generate tags
" On Debian/Ubuntu: sudo apt install universal-ctags  (or exuberant-ctags)
" On macOS (Homebrew): brew install --HEAD universal-ctags
" You can also specify a custom ctags executable if it's in a non-standard location:
" let g:gutentags_ctags_executable = '/usr/local/bin/ctags'

" If you prefer to disable Gutentags entirely when ctags isn't available:
" let g:gutentags_enabled = []

