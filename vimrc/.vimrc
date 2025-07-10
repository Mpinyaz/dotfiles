" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do not delete the `UNIQUE_ID` line below, I use it to backup original files
" so they're not lost when my symlinks are applied
" UNIQUE_ID=do_not_delete_this_line
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filename: ~/github/dotfiles-latest/vimrc/vimrc-file
" ~/github/dotfiles-latest/vimrc/vimrc-file

" Set leader key to spacebar
let mapleader = " "

" Set local leader for buffer-specific mappings
let maplocalleader = ","

" =============================================================================
" GENERAL SETTINGS
" =============================================================================
set nobackup
set nowb
set noswapfile

" Set Vim's operating mode to nocompatible with Vi (Vim's default behavior)
" This allows Vim to use features not found in standard Vi.
set nocompatible

" Enable line numbers
set number
set relativenumber

" Set tabs to have 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Enable syntax highlighting
syntax on

" Enable file type detection and plugin loading
filetype plugin indent on

" I always want to show the status line at the bottom (0 never, 1 if 2 windows, 2 always)
set laststatus=2

" Allows me to delete characters when type backspace in insert mode
set backspace=indent,eol,start

" I always like lines to be broken at 80 characters
" For my sticky notes I set it to something different in that vimrc file
set textwidth=80

" Disable line wrapping
" I had to disable this for my bulletpoints to work
set nowrap

" I need this so that indentation works properly with bulletpoints and the
" bullets.vim plugin
set autoindent

" Show matching brackets/parenthesis
set showmatch

" Set the default search to case-insensitive
set ignorecase

" But make search case-sensitive if it contains uppercase characters
set smartcase

" Highlight search results
set hlsearch

" Show search matches as you type
set incsearch

" Enable mouse in all modes
set mouse=a

" Better command-line completion
set wildmenu
set wildmode=list:longest,full

" Show partial commands in the last line
set showcmd

" Better splitting behavior
set splitbelow
set splitright

" Persistent undo
set undofile
set undodir=~/.vim/undodir

" Faster updates
set updatetime=250

" Always show sign column to avoid text shifting
set signcolumn=yes

" Better scrolling
set scrolloff=8
set sidescrolloff=8

" =============================================================================
" APPEARANCE & COLORS
" =============================================================================

" Change the color of visually or visual selected text
highlight Visual ctermfg=white ctermbg=blue guifg=white guibg=blue

" Info to be shown in the status line
" %f filename, %y filetype, %m modified flag, %r RO flag, %= align to right, %l line, %c column
set statusline=%f\ %y\ %m\ %r\ %=Line:\ %l\ Column:\ %c

" Define custom highlight color for inline code in Markdown
autocmd FileType markdown highlight markdownCode ctermfg=yellow ctermbg=NONE

" Set cursor to line in insert mode
let &t_SI = "\e[5 q"

" Set cursor to block in normal mode
let &t_EI = "\e[2 q"

" This fixed paste issues in tmux
" https://vi.stackexchange.com/questions/23110/pasting-text-on-vim-inside-tmux-breaks-indentation
if &term =~ "screen"
    let &t_BE = "\e[?2004h"
    let &t_BD = "\e[?2004l"
    exec "set t_PS=\e[200~"
    exec "set t_PE=\e[201~"
endif

" =============================================================================
" CUSTOM TEXT OBJECTS
" =============================================================================

" Text object for entire buffer
onoremap ae :<C-u>normal! ggVG<CR>
vnoremap ae :<C-u>normal! ggVG<CR>

" Text object for entire line (without newline)
onoremap al :<C-u>normal! 0v$h<CR>
vnoremap al :<C-u>normal! 0v$h<CR>

" Text object for current line content (excluding leading/trailing whitespace)
onoremap il :<C-u>normal! ^vg_<CR>
vnoremap il :<C-u>normal! ^vg_<CR>

" Text object for numbers
onoremap in :<C-u>call SelectNumber()<CR>
vnoremap in :<C-u>call SelectNumber()<CR>

function! SelectNumber()
    let saved_reg = @"
    normal! viW"vy
    let word = @"
    let @" = saved_reg
    let num_pattern = '\d\+'
    let start_pos = match(word, num_pattern)
    if start_pos != -1
        let end_pos = matchend(word, num_pattern) - 1
        normal! viW
        exe "normal! " . (start_pos + 1) . "l"
        exe "normal! v" . (end_pos - start_pos) . "l"
    endif
endfunction

" Text object for markdown links
onoremap il :<C-u>call SelectMarkdownLink()<CR>
vnoremap il :<C-u>call SelectMarkdownLink()<CR>

function! SelectMarkdownLink()
    let save_cursor = getpos(".")
    if search('\[', 'bc', line('.')) && search('\]', 'ce', line('.'))
        normal! v`[
    else
        call setpos('.', save_cursor)
    endif
endfunction

" =============================================================================
" KEY MAPPINGS
" =============================================================================

" Mapping to enter command mode
" inoremap didn't work with obsidian so switched to imap
imap jk <Esc>

" When in visual mode, you can move lines of text up and down
" Enter visual mode, select what you need to select and press J or K to move
" the section up or down
vmap J :m '>+1<CR>gv=gv
vmap K :m '<-2<CR>gv=gv

" When going down or up, centers cursor in the middle of the screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Toggle line numbers with mn
nnoremap mn :set number!<CR>

" Toggle relative line numbers
nnoremap mr :set relativenumber!<CR>

" When searching and do n or N, cursor stays in the middle
nnoremap n nzzzv
nnoremap N Nzzzv

" Clear search highlighting
nnoremap <leader>h :nohlsearch<CR>

" Copy to the system clipboard either in normal or visual mode
" In visual mode, select the text and then do <Leader>y to copy it
" If in normal mode do <Leader>y then 'ap' to copy a paragraph
nnoremap <Leader>y "+y
vmap <Leader>y "+y
nnoremap <Leader>Y "+Y

" Paste from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Q enters Ex mode, this disables it
nnoremap Q <nop>

" Use gh to move to the beginning of the line in normal mode
" Use gl to move to the end of the line in normal mode
nnoremap gh ^
nnoremap gl $

" Better navigation: when no count is given, use gj/gk for j/k
" Obsidian compatible
nnoremap j gj
nnoremap k gk

" This is for visual mode, but didn't work in obsidian
xnoremap j gj
xnoremap k gk

" Use leader+w to save or write files
nnoremap <leader>ww :w<cr>

" Create a task used with bullets plugin
nnoremap <leader>ml i- [ ] <Esc>a

" Copy to the system clipboard
vnoremap y "+y
nnoremap y "+y

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrow keys
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Open new splits
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>

" Close current buffer
nnoremap <leader>bd :bd<CR>

" Switch between buffers
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>

" Quick save and quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Select all
nnoremap <leader>a ggVG

" Better indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Increment/decrement numbers
nnoremap + <C-a>
nnoremap - <C-x>

" =============================================================================
" ADVANCED MAPPINGS
" =============================================================================

" Duplicate line
nnoremap <leader>d :t.<CR>

" Delete line without yanking
nnoremap <leader>x "_dd

" Change word under cursor
nnoremap <leader>cw ciw

" Change word under cursor globally
nnoremap <leader>cW :%s/\<<C-r><C-w>\>//g<Left><Left>

" Search for word under cursor
nnoremap <leader>* *N

" Insert blank line above/below
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

" Toggle fold
nnoremap <Space> za

" =============================================================================
" PLUGIN MANAGEMENT
" =============================================================================

" vim-plug automatic installation
" This code goes in your .vimrc before plug#begin() call
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Remember that before this call you need to have the vim-plug automatic
" installation section
call plug#begin()

" List your plugins here
Plug 'bullets-vim/bullets.vim'

" Enhanced text objects
Plug 'wellle/targets.vim'              " More text objects (., ,, ;, etc.)
Plug 'tpope/vim-surround'              " Surround text objects (cs, ds, ys)
Plug 'tpope/vim-repeat'                " Repeat plugin commands with .
Plug 'michaeljsmith/vim-indent-object' " Indentation text objects (ai, ii)

" Enhanced functionality
Plug 'tpope/vim-commentary'            " Comment/uncomment with gc
Plug 'tpope/vim-unimpaired'            " Bracket mappings for navigation
Plug 'justinmk/vim-sneak'              " Fast navigation with s{char}{char}
Plug 'easymotion/vim-easymotion'       " Quick navigation

" File and project management
Plug 'preservim/nerdtree'              " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                " Fuzzy finder

" Git integration
Plug 'tpope/vim-fugitive'              " Git commands in Vim
Plug 'airblade/vim-gitgutter'          " Git diff in sign column

" Status line enhancement
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" =============================================================================
" PLUGIN CONFIGURATIONS
" =============================================================================

" NERDTree configuration
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" FZF configuration
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fh :History<CR>

" Sneak configuration
let g:sneak#label = 1
let g:sneak#s_next = 1

" EasyMotion configuration
map <leader>s <Plug>(easymotion-s2)
map <leader>/ <Plug>(easymotion-sn)

" Airline configuration
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Gruvbox configuration
set background=dark
colorscheme gruvbox

" =============================================================================
" AUTOCMDS
" =============================================================================

augroup CustomSettings
    autocmd!

    " Remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Return to last edit position when opening files
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Auto-create directories when saving files
    autocmd BufWritePre * if expand('<afile>') !~ '^scp:' | call mkdir(expand('%:h'), 'p') | endif

    " Markdown specific settings
    autocmd FileType markdown setlocal textwidth=80 wrap linebreak

    " Python specific settings
    autocmd FileType python setlocal textwidth=88

augroup END

" =============================================================================
" FUNCTIONS
" =============================================================================

" Toggle between relative and absolute line numbers
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" Quick fix toggle
function! QuickfixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <leader>q :call QuickfixToggle()<CR>

" =============================================================================
" FINAL SETTINGS
" =============================================================================

" Enable folding
set foldmethod=indent
set foldlevel=99

" Better completion
set completeopt=menuone,noinsert,noselect

" Don't show mode in command line (airline shows it)
set noshowmode
