set nocompatible

" }}}
" Basic options -----------------------------------------------------------

set visualbell
set history=1000
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
set title
set linebreak
set colorcolumn=+1
" Remove message from when you start vim
set shortmess+=I

" Spelling
"
" There are three dictionaries I use for spellchecking:
"
"   /usr/share/dict/words
"   Basic stuff.
"
"   ~/.vim/custom-dictionary.utf-8.add
"   Custom words (like my name).  This is in my (version-controlled) dotfiles.
"
"   ~/.vim-local-dictionary.utf-8.add
"   More custom words.  This is *not* version controlled, so I can stick
"   work stuff in here without leaking internal names and shit.
"
" I also remap zG to add to the local dict (vanilla zG is useless anyway).
set dictionary=/usr/share/dict/words
set spellfile=~/.vim/custom-dictionary.utf-8.add,~/.vim-local-dictionary.utf-8.add
nnoremap zG 2zg

" iTerm2 is currently slow as balls at rendering the nice unicode lines, so for
" now I'll just use ASCII pipes.  They're ugly but at least I won't want to kill
" myself when trying to move around a file.
set fillchars=diff:⣿,vert:│
set fillchars=diff:⣿,vert:\|

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=500

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Resize splits when the window is resized
au VimResized * :wincmd =

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}

" Backups {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif

" }}}

" Copying text to the system clipboard.
"
" For some reason Vim no longer wants to talk to the OS X pasteboard through "*.
" Computers are bullshit.
function! g:FuckingCopyTheTextPlease()
  let old_z = @z
  normal! gv"zy
  call system('pbcopy', @z)
  let @z = old_z
endfunction
noremap <leader>p :silent! set paste<CR>"*p:set nopaste<CR>
" noremap <leader>p mz:r!pbpaste<cr>`z
vnoremap <leader>y :<c-u>call g:FuckingCopyTheTextPlease()<cr>
nnoremap <leader>y VV:<c-u>call g:FuckingCopyTheTextPlease()<cr>

" "Uppercase word" mapping.
"
" This mapping allows you to press <c-u> in insert mode to convert the current
" word to uppercase.  It's handy when you're writing names of constants and
" don't want to use Capslock.
"
" To use it you type the name of the constant in lowercase.  While your
" cursor is at the end of the word, press <c-u> to uppercase it, and then
" continue happily on your way:
"
"                            cursor
"                            v
"     max_connections_allowed|
"     <c-u>
"     MAX_CONNECTIONS_ALLOWED|
"                            ^
"                            cursor
"
" It works by exiting out of insert mode, recording the current cursor location
" in the z mark, using gUiw to uppercase inside the current word, moving back to
" the z mark, and entering insert mode again.
"
" Note that this will overwrite the contents of the z mark.  I never use it, but
" if you do you'll probably want to use another mark.
inoremap <C-u> <esc>mzgUiw`za

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Toggle paste
" For some reason pastetoggle doesn't redraw the screen (thus the status bar
" doesn't change) while :set paste! does, so I use that instead.
" set pastetoggle=<F6>
nnoremap <F6> :set paste!<cr>


set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set expandtab
set smarttab                                        "use shiftwidth to enter tabs

" Toggle line numbers
nnoremap <leader>l :setlocal number!<cr>

set laststatus=2 " Always show the statusline
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
set ttyfast
set fileformats+=mac "add mac to auto-detection of file format line endings
set nrformats-=octal                                "always assume decimal numbers

" Hide tab bar
set showtabline=0

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" ---------------
" Behaviors
" ---------------
syntax enable
"set autoread " Automatically reload changes if detected
set wildmenu " Turn on WiLd menu
set hidden " Change buffer - without saving
set cf " Enable error files & error jumping.
"set clipboard+=unnamed " Yanks go on clipboard instead.
set autowrite " Writes on make/shell commands
set nofoldenable " Disable folding entirely.
set foldlevelstart=99 " I really don't like folds.
set formatoptions=crql
set iskeyword+=\$,- " Add extra characters that are valid parts of variables
set nostartofline " Don't go to the start of the line after some commands
set scrolloff=3 " Keep three lines below the last line when scrolling
set gdefault " this makes search/replace global by default
set switchbuf=useopen " Switch to an existing buffer if one exists

" ---------------
" Visual
" ---------------
set showmatch " Show matching brackets.
set matchtime=2 " How many tenths of a second to blink
" Show trailing spaces as dots and carrots for extended lines.
" From Janus, http://git.io/PLbAlw
" Reset the listchars
set listchars=""
" make tabs visible
set listchars=tab:▸▸
" show trailing spaces as dots
set listchars+=trail:•
" The character to show in the last column when wrap is off and the line
" continues beyond the right of the screen
set listchars+=extends:>
" The character to show in the last column when wrap is off and the line
" continues beyond the right of the screen
set listchars+=precedes:<

" ----------------------------------------
" Commands
" ----------------------------------------
" Silently execute an external command
" No 'Press Any Key to Contiue BS'
" from: http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
command! -nargs=1 SilentCmd
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'
" Fixes common typos
command! W w
command! Q q

" display incomplete commands
set showcmd
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
let mapleader="\<Space>"

set modelines=0 " prevents some security exploits having to do with modelines in files.

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
" Plugin 'tpope/vim-markdown'
" Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
" Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-ragtag'
"Plugin 'sjl/gundo.vim'
"Plugin 'vim-scripts/pep8'
"Plugin 'fs111/pydoc.vim'
Plugin 'terryma/vim-multiple-cursors'
" Plugin 'fatih/vim-go.git'
Plugin 'kien/ctrlp.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'marijnh/tern_for_vim'
Plugin 'Raimondi/delimitMate'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/syntastic'
" Plugin 'Lokaltog/vim-easymotion'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'airblade/vim-gitgutter'
Plugin 'ap/vim-css-color'
"Plugin 'scrooloose/nerdtree'
Plugin 'def-lkb/ocp-indent-vim'
" Plugin 'sergi/vim-pml'
Plugin 'panozzaj/vim-autocorrect'
"Plugin 'tomtom/tlib_vim'
"Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'regedarek/ZoomWin'
"Plugin 'amdt/vim-niji'
Plugin 'mephux/vim-jsfmt'
Plugin 'mxw/vim-jsx'
"Plugin 'tpope/vim-fireplace'
"Plugin 'tpope/vim-leiningen'
Plugin 'rking/ag.vim'
"Plugin 'cespare/vim-sbd'
Plugin 'jpalardy/vim-slime'
Plugin 'vim-scripts/paredit.vim'
Plugin 'xolox/vim-misc.git'
Plugin 'xolox/vim-session'
"Plugin 'sergi/vim-chicken-doc'
"Plugin 'ervandew/supertab'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'bling/vim-airline'
Plugin 'wlangstroth/vim-racket'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'NLKNguyen/papercolor-theme'

" Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

"Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'

"Scala
"Plugin 'derekwyatt/vim-scala'

let g:vim_markdown_frontmatter=1
let g:netrw_liststyle=3

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "2"}

nnoremap <silent> <leader>bd    :Sbd<CR>
nnoremap <silent> <leader>bdm   :Sbdm<CR>

" --- type _ to search the word in all files in the current dir
" nmap _ :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Ag"

inoremap <C-c> <CR><Esc>O

call vundle#end()
filetype off
filetype plugin indent on

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

set showmode                      " Display the mode you're in.
set guifont=Inconsolata-dz\ for\ Powerline
set fillchars+=stl:\ ,stlnc:\

set number

" folds {{{
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>
" }}}

set wrap
set textwidth=79
"set formatoptions=qrn1
set colorcolumn=80

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

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

set relativenumber
set ruler                         " Show cursor position.
set backspace=indent,eol,start    " Intuitive backspacing.
set undofile " tells Vim to create <FILENAME>.un~ files whenever you edit a file. "

"nnoremap <C-j> o<Esc>k$
set wildignore+=vendor,log,tmp,*.swp,*.o,*.obj,*.pyc,*.swc,*.DS_STORE,*.bkp,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,
      \.sass-cache,*.class,*.scssc,*.cssc,sprockets%*,*.lessc,*/node_modules/*,
      \rake-pipeline-*
"set lines=60 columns=180
nnoremap <F4> :buffers<CR>:buffer<space>

"Remove MacVim's toolbar
if has("gui_running")
  set guioptions=egmrt
endif

" on save any: trim trailing whitespace
autocmd! BufWrite * mark ' | silent! %s/\s\+$// | norm ''

iab funciton function

" for mistyping :w as :W
command! W :w
set t_Co=256
colorscheme hybrid
let g:hybrid_use_Xresources = 1

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

" Type <Space>o to open a new file
nnoremap <Leader>o :CtrlP<CR>
" Type <Space>w to save file (a lot faster than :w<Enter>)
nnoremap <Leader>w :w<CR>
" Enter visual line mode with <Space><Space>:
nmap <Leader><Leader> V
"Copy & paste to system clipboard with <Space>p and <Space>y:
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Insert newline without entering Insert
nmap <CR> m`o<Esc>``
" Map ✠ (U+2720) to <S-CR>, so we have <S-CR> mapped to ✠ in iTerm2 and
" ✠ mapped back to <S-CR> in Vim.
nmap ✠ m`O<Esc>``

let g:ctrlp_working_path_mode = 'r'
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_cmd = 'CtrlPMRU .'

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_gjslint_args="--nojsdoc"
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
" highlight SyntasticErrorSign guifg=red guibg=red
" highlight SyntasticError guibg=#2f0000

let g:syntastic_ocaml_use_ocamlc = 1

if exists('$ITERM_PROFILE')
  if exists('$TMUX')
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

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

map <silent> <F8>   :Explore<CR>
map <silent> <S-F8> :sp +Explore<CR>
" Format the whole document and go back to the position we were
nnoremap <C-f> mtgg=G'tzz
inoremap <C-f> <ESC><C-f>

" Ctrl-s saves file
nnoremap <c-s> :w<CR>
inoremap <c-s> <Esc>:w<CR>a

let maplocalleader = "\\"

" source ~/.vim/.vim_statusbar

au BufEnter *.ml setf ocaml
au BufEnter *.mli setf ocaml

" Use ag over grep
set grepprg=ag\ --nogroup\ --nocolor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"let g:ctrlp_user_command = "find %s -type f | egrep -v '/\.(git|hg|svn)|solr|tmp/' | egrep -v '\.(png|exe|jpg|gif|jar|class|swp|swo|log|gitkep|keepme|so|o)$'"
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_max_files=0

let g:gitgutter_max_signs=5000

" PML file settings
augroup filetype_pml
    autocmd!
    au BufNewFile,BufRead *.pml set ft=xml
    autocmd FileType pml  set ft=xml
    autocmd FileType pml call AutoCorrect()
    au BufRead,BufNewFile *.pml setlocal spell
augroup END

iab JAvaScript JavaScript

" Omni Completion settings
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
      \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
      \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" ---------------
" Paste using Paste Mode
"
" Keeps indentation in source.
" ---------------
function! PasteWithPasteMode()
  if &paste
    normal p
  else
    " Enable paste mode and paste the text, then disable paste mode.
    set paste
    normal p
    set nopaste
  endif
endfunction
command! PasteWithPasteMode call PasteWithPasteMode()
nnoremap <silent> <leader>p :PasteWithPasteMode<CR>

"Append this to your .vimrc to add merlin to vim's runtime-path:
let g:opamshare = substitute(system('opam config var share'),'\n$','','')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

let g:syntastic_ocaml_checkers = ['merlin']

if $TMUX == ''
  set clipboard+=unnamed
endif
" Toggle Paste mode
noremap <silent> <leader>o :set paste!<CR>

let g:syntastic_racket_code_ayatollah_script = '/Users/sergi/.vim/code-ayatollah.rkt'

" More granular undo (undo step after each space)
inoremap <Space> <Space><C-G>u

let g:session_autoload = 'no'

" Sergi's mappings
nnoremap <leader>- ddp
nnoremap <leader>_ kddpk

inoremap <c-u> <esc>viw~i

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
inoremap kj <esc>

let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#hunks#enabled = 1

func! WordProcessorMode()
  setlocal formatoptions=cqt
  " setlocal noexpandtab
  map j gj
  map k gk
  setlocal spell spelllang=en_us
  set thesaurus+=/Users/sbrown/.vim/thesaurus/mthesaur.txt
  set complete+=s
  set formatprg=par
  setlocal wrap
  setlocal linebreak
endfu
com! WP call WordProcessorMode()

if exists('$TMUX')
  set term=screen-256color
endif

let delimitMate_expand_cr = 2
