"        _
"       (_)
"__   __ _   _ __ ___     _ __    ___
"\ \ / / | | | '_ ` _ \   | '__|  / __|
" \ V /  | | | | | | | | | |     | (__
"  \_/   |_| |_| |_| |_| |_|      \___|
"=====================SOURCE FILES========
source ~/.config/nvim/cocConfig.vim
source ~/.config/nvim/keyBinding.vim

"=====================GENERAL=============
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

autocmd BufWritePre *.* :%s/\s\+$//e
syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set noshowmode               "do not show --Insert-- and other modes
set showtabline=3
set wrap linebreak           "set line wrap"
set rnu
set shortmess=at            "disable welcome message"
set cursorline
set ignorecase
set equalalways
set background=dark
set encoding=UTF-8
set mouse=
set hidden
autocmd VimResized * wincmd =

"=====================PLUGINS=============
call plug#begin('~/.vim/plugged')
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'
Plug 'dracula/vim', { 'name': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'pangloss/vim-javascript'
Plug 'cocopon/iceberg.vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-surround'
Plug 'ryanoasis/vim-devicons'
Plug 'ekalinin/Dockerfile.vim'
Plug 'voldikss/vim-floaterm'
Plug 'akinsho/bufferline.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'coder/claudecode.nvim'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
call plug#end()

"=====================THEME LAYER=========
colorscheme iceberg
set background=dark

" Your transparency overrides are officially BACK:
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

" Fix status bars to also respect the transparency aesthetic:
hi! StatusLine ctermbg=NONE guibg=NONE
hi! StatusLineNC ctermbg=NONE guibg=NONE
hi! TabLineFill ctermbg=NONE guibg=NONE
hi! TabLine ctermbg=NONE guibg=NONE

"=====================MAPPINGS============
nnoremap n nzz
nnoremap N Nzz

if executable('rg')
    let g:rg_derive_root='true'
endif

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

let mapleader = " "
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nnoremap <f4> %x``x
nnoremap <leader><leader> :nohls <cr>

nnoremap <leader>ev :tabedit ~/.vimrc<cr>
nnoremap <leader>c :Goyo <cr>
nnoremap <tab> <c-w><c-w>
nnoremap <leader>u :UndotreeShow<cr>
nnoremap <leader>ps :Rg<SPACE>

"=====================GVIM CONFIG===================
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

if has("gui_running")
    autocmd GUIEnter * set vb t_vb=
    set lines=999 columns=999
    set background=light
endif

"================EMMET config=======================
let g:user_emmet_leader_key=','
let g:user_emmet_settings = {
            \   'javascript.jsx' : {
            \       'extends' : 'jsx',
            \   },
            \}

"================NERDTREE CONFIG===================
autocmd VimEnter * wincmd p
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '|'
let g:NERDTreeDirArrowCollapsible = '|'
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows =0
let NERDTreeShowHidden =1
let g:NERDTreeWinSize=30
let g:NERDTreeGitStatusWithFlags = 0
nmap <Leader>r :NERDTreeFocus<cr>R<-w><c-p>
let g:NERDTreeWinPos = "left"

"================ STATUS LINE CONFIG================
let g:lightline = {
            \ 'colorscheme': 'iceberg',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \    'pwd':'!pwd',
            \   'filename': 'helpers#lightline#fileName',
            \   'fileformat': 'helpers#lightline#fileFormat',
            \   'currentfunction': 'helpers#lightline#currentFunction',
            \ },
            \   'tabline': {
            \       'left': [ [ 'tabs' ] ],
            \       'right': [ [ 'close' ] ]
            \   },
            \   'tab': {
            \       'active': [ 'filetype', 'filename', 'modified' ],
            \       'inactive': [ 'filetype', 'filename', 'modified' ],
            \   },
            \ }

"================FZF SETTINGS======================
nnoremap <C-f> :GFiles<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>

let g:fzf_preview_window = ['right:20%', 'ctrl-/']
let g:fzf_layout = {'up':'15%', 'window': { 'width': 0.9, 'height': 0.5,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'rounded' } }

if has("autocmd")
    autocmd bufwritepost vimrc source $MYVIMRC
endif

inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha

nnoremap <silent> <c-Up> :resize -1<CR>
nnoremap <silent> <c-Down> :resize +1<CR>
nnoremap <silent> <c-left> :vertical resize -1<CR>
nnoremap <silent> <c-right> :vertical resize +1<CR>

nnoremap <C-t> :tabedit<CR>
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"================GOYO UTILS=========================
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set number
endfunction

let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

iabbrev teh the
iabbrev ed export default
iabbrev imf import from
iabbrev cf const = () => {return}
command! -nargs=0 Prettier :all CocAction('runCommand', 'prettier.formatFile')
autocmd FileType scss setl iskeyword+=@-@

nnoremap <leader>ac :FloatermNew<CR>

"=====================GO CONFIGURATIONS=============
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []
let g:go_jump_to_error = 0
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 0

lua << EOF
require("claudecode").setup({
  terminal = {
    split_side = "right",
    split_width_percentage = 0.35,
  },
})
EOF

nnoremap <leader>ai :ClaudeCode<CR>
nnoremap <leader>as :ClaudeCodeSend<CR>
vnoremap <leader>as :ClaudeCodeSend<CR>
