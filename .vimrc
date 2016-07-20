set nocompatible




" }}}
" Basic options -----------------------------------------------------------

set visualbell
set history=1000
set undoreload=10000
set list                " Display whitespace
set lazyredraw          " Redraw only when we need to."
set showbreak=↪
set splitbelow          " Make the new window appear below the current window.
set splitright          " Make the new window appear on the right
set autowrite           " Save the file when you switch buffers
set autoread
set shiftround          " use multiple of shiftwidth when indenting with '<' and '>'
set title               " change the terminal's title
set linebreak           " only wrap at a character in the breakat option
set shortmess+=I        " Remove message from when you start vim
set nowrap

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

" Toggle line numbers
nnoremap <leader>l :setlocal number!<cr>

set laststatus=2 " Always show the statusline
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set cursorline          " highlight current line"
"set cmdheight=2
set number              " show line numbers"
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
set wildmenu " visual autocomplete for command menu
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
set showmatch           " highlight matching [{()}]
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
let mapleader=","

set modelines=0 " prevents some security exploits having to do with modelines in files.

" Plug
" Setting up Plug - A minimalist Vim plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source ~/.vimrc
endif

call plug#begin('~/.vim/bundle')
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-ragtag', { 'for': ['html', 'xml', 'pml'] }
Plug 'tpope/vim-unimpaired'
Plug 'terryma/vim-multiple-cursors'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'ctrlpvim/ctrlp.vim', { 'on':  'CtrlP' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jason0x43/vim-js-indent', { 'for': 'javascript' }
" Plug 'leafgarland/typescript-vim'
" Plug 'Quramy/tsuquyomi', { 'for': 'typescript' }
Plug 'othree/jsdoc-syntax.vim', { 'for': ['javascript'] }
Plug 'mxw/vim-jsx'
Plug 'Raimondi/delimitMate'
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Lokaltog/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
" Plug 'panozzaj/vim-autocorrect'
Plug 'regedarek/ZoomWin'
Plug 'jpalardy/vim-slime', { 'for': ['clojure', 'scheme', 'ocaml'] }
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }
" Plug 'bling/vim-airline'
Plug 'itchyny/lightline.vim'

Plug 'wlangstroth/vim-racket', { 'for': ['scheme'] }
Plug 'kien/rainbow_parentheses.vim', { 'for': ['clojure', 'scheme'] }
Plug 'NLKNguyen/papercolor-theme'

" Markdown
Plug 'godlygeek/tabular', { 'for': ['markdown', 'txt'] }
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" Plug 'lambdatoast/elm.vim'
Plug 'marijnh/tern_for_vim', { 'for': ['javascript'], 'do': 'npm install' }

" Tern goodness
autocmd FileType javascript setlocal omnifunc=tern#Complete

call plug#end()

let g:tern_map_keys = 1

let g:tern_show_argument_hints = 'on_hold'
let g:sneak#streak = 1

let g:netrw_liststyle=3

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "2"}

nnoremap <silent> <leader>bd    :Sbd<CR>
nnoremap <silent> <leader>bdm   :Sbdm<CR>

" --- type _ to search the word in all files in the current dir
" nmap _ :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>a :Ag"

inoremap <C-c> <CR><Esc>O

filetype off
filetype plugin indent on

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

set showmode                      " Display the mode you're in.
set guifont=Inconsolata-dz\ for\ Powerline


" folds {{{
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>
" }}}

set textwidth=79
"set formatoptions=qrn1
set colorcolumn=80

" move vertically by visual line
nnoremap j gj
nnoremap k gk

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

" on save any: trim trailing whitespace
autocmd! BufWrite * mark ' | silent! %s/\s\+$// | norm ''

iab funciton function
iab JAvaScript JavaScript

" for mistyping :w as :W
command! W :w
set t_Co=256
colorscheme PaperColor
" let g:hybrid_use_Xresources = 1

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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers = ['eslint', 'gjslint']
"let g:syntastic_javascript_eslint_exec = 'eslint_d'
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

set omnifunc=syntaxcomplete#Complete
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

let g:gitgutter_max_signs=3000

" PML file settings
augroup filetype_pml
    autocmd!
    au BufNewFile,BufRead *.pml set ft=xml
    autocmd FileType pml  set ft=xml
    autocmd FileType pml call AutoCorrect()
    au BufRead,BufNewFile *.pml setlocal spell
augroup END

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
" let g:opamshare = substitute(system('opam config var share'),'\n$','','')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"

" let g:syntastic_ocaml_checkers = ['merlin']

if $TMUX == ''
  set clipboard+=unnamed
endif

" Toggle Paste mode
noremap <silent> <leader>o :set paste!<CR>

" More granular undo (undo step after each space)
inoremap <Space> <Space><C-G>u

" Sergi's mappings
nnoremap <leader>- ddp
nnoremap <leader>_ kddpk
inoremap <c-u> <esc>viw~i
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
inoremap kj <esc>

" let g:airline_powerline_fonts = 1
" let g:airline#extensions#syntastic#enabled = 1
" let g:airline#extensions#hunks#enabled = 1
let delimitMate_expand_cr = 2
let g:neocomplete#enable_at_startup = 1
let g:EditorConfig_core_mode = 'external_command'
let g:jsx_ext_required = 0 " Allow JSX in normal JS files"
let NERDSpaceDelims=1 " Add whitespace before comment

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

function! Multiple_cursors_before()
  exe 'NeoCompleteLock'
  echo 'Disabled autocomplete'
endfunction

function! Multiple_cursors_after()
  exe 'NeoCompleteUnlock'
  echo 'Enabled autocomplete'
endfunction


func! WordProcessorMode()
  setlocal formatoptions=cqt
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
