set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set tabstop=2
set shiftwidth=2
set laststatus=2 " Always show the statusline
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
"set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set background=dark
set mouse=a
" Set xterm2 mouse mode to allow resizing of splits with mouse inside Tmux.
set ttymouse=xterm2
set mousehide
set history=1000
set ttyfast
set fileformats+=mac "add mac to auto-detection of file format line endings
set nrformats-=octal                                "always assume decimal numbers

" Hide tab bar
set showtabline=0

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","

set modelines=0 " prevents some security exploits having to do with modelines in files.

call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

set showmode                      " Display the mode you're in.
set guifont=Inconsolata:h16
set number

set autoindent
set smartindent
set expandtab
set smarttab                                        "use shiftwidth to enter tabs
let &showbreak='↪ '
set gdefault "global replace

" folds {{{
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>
" }}}

" sane regex {{{
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
cnoremap s/ s/\v
"}}}

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=80

set list
set listchars=tab:▸\ ,eol:¬

" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" open a new vertical split and switch over to it.
"nnoremap <leader>w <C-w>v<C-w>l
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

" au FocusLost * :wa " Save on lost focus

inoremap jj <ESC>

set encoding=utf-8
set fileencoding=utf-8
set relativenumber
set ruler                         " Show cursor position.
set backspace=indent,eol,start    " Intuitive backspacing.
set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set undodir=/Volumes/Macintosh\ HD/.vimundo,.
set undofile " tells Vim to create <FILENAME>.un~ files whenever you edit a file. "

nnoremap <C-j> o<Esc>k$
set wildignore+=vendor,log,tmp,*.swp,*.o,*.obj,*.pyc,*.swc,*.DS_STORE,*.bkp
"set lines=60 columns=180
nnoremap <F4> :buffers<CR>:buffer<space>

"Remove MacVim's toolbar
if has("gui_running")
    set guioptions=egmrt
endif

" on save any: trim trailing whitespace
autocmd! BufWrite * mark ' | silent! %s/\s\+$// | norm ''

au BufNewFile,BufRead *.sjs set filetype=javascript

iab funciton function

" for mistyping :w as :W
command! W :w
set t_Co=256
"colorscheme tomorrow-night
let base16colorspace=256
colorscheme base16-default

" Rainbox Parentheses {{{

nnoremap <leader>R :RainbowParenthesesToggle<cr>
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
nnoremap ,cd :lcd %:p:h<CR>:pwd<CR>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Clear search highlights
noremap <silent><Leader>/ :nohls<CR>

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

map <c-f> :call JsBeautify()<cr>

" let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cmd = 'CtrlP .'

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers = ['jshint', 'gjslint']
let g:syntastic_javascript_gjslint_args="--nojsdoc"
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'

let g:syntastic_ocaml_use_ocamlc = 1
let g:syntastic_ocaml_use_janestreet_core = 1
let g:syntastic_ocaml_janestreet_core_dir = '/Users/sergi/.opam/4.01.0dev+trunk/lib/core/'

"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" set 'updatetime' to 15 seconds when in insert mode
 au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
 au InsertLeave * let &updatetime=updaterestore
" Automatically leave insert mode after 'updatetime' (4s by default).
au CursorHoldI * stopinsert

"Go Language Stuff
au FileType go au BufWritePre <buffer> Fmt "Format on save

set omnifunc=syntaxcomplete#Complete
let g:tern_map_keys=1
let g:tern_show_argument_hints='on_hold'
map <Leader> <Plug>(easymotion-prefix)

set term=screen-256color

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

let s:ocamlmerlin=substitute(system('opam config var share'),'\n$','','''') .  "/ocamlmerlin"
execute "set rtp+=".s:ocamlmerlin."/vim"
execute "set rtp+=".s:ocamlmerlin."/vimbufsync"

autocmd FileType ocaml source /Users/sergi/.opam/4.01.0dev+trunk/share/vim/syntax/ocp-indent.vim
