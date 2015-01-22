set nocompatible
set tabstop=2
set shiftwidth=2
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

" -----------------------------
" File Locations
" -----------------------------
set backupdir=~/.vim/.backup
set directory=~/.vim/.tmp

" Persistent Undo
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/.undo
endif

" ---------------
" Behaviors
" ---------------
syntax enable
set backup " Turn on backups
"set autoread " Automatically reload changes if detected
set wildmenu " Turn on WiLd menu
set hidden " Change buffer - without saving
set history=768 " Number of things to remember in history.
set cf " Enable error files & error jumping.
"set clipboard+=unnamed " Yanks go on clipboard instead.
set autowrite " Writes on make/shell commands
" set timeoutlen=450 " Time to wait for a command (after leader for example).
set ttimeout
set ttimeoutlen=100 " Time to wait for a command (after leader for example).
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
" Show invisible characters
set list
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

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'pangloss/vim-javascript'
"Plugin 'sjl/gundo.vim'
"Plugin 'vim-scripts/pep8'
"Plugin 'fs111/pydoc.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'fatih/vim-go.git'
Plugin 'chriskempson/base16-vim'
Plugin 'kien/ctrlp.vim'
"Plugin 'jelera/vim-javascript-syntax'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/syntastic'
Plugin 'marijnh/tern_for_vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'airblade/vim-gitgutter'
Plugin 'ap/vim-css-color'
Plugin 'tpope/vim-ragtag'
Plugin 'scrooloose/nerdtree'
Plugin 'def-lkb/ocp-indent-vim'
"Plugin 'sergi/vim-pml'
Plugin 'panozzaj/vim-autocorrect'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'regedarek/ZoomWin'
Plugin 'amdt/vim-niji'
Plugin 'mephux/vim-jsfmt'

call vundle#end()
filetype off
filetype plugin indent on

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

set showmode                      " Display the mode you're in.
set guifont=Inconsolata:h16
set number

set autoindent
set smartindent
set expandtab
set smarttab                                        "use shiftwidth to enter tabs
"let &showbreak='~'
set gdefault "global replace

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

inoremap jj <ESC>

set encoding=utf-8
set fileencoding=utf-8
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

let g:ctrlp_working_path_mode = 'r'
"let g:ctrlp_working_path_mode = 0
let g:ctrlp_cmd = 'CtrlPMRU .'

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers = ['jshint', 'gjslint']
let g:syntastic_javascript_gjslint_args="--nojsdoc"
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'

let g:syntastic_ocaml_use_ocamlc = 1
"let g:syntastic_ocaml_use_janestreet_core = 1
"let g:syntastic_ocaml_janestreet_core_dir = '/Users/sergi/.opam/4.01.0dev+trunk/lib/core/'

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

map <silent> <F8>   :Explore<CR>
map <silent> <S-F8> :sp +Explore<CR>
map <silent><buffer><C-S-j> :%! js-beautify -s 2 -file -<CR>
" Format the whole document and go back to the position we were
nmap <C-f> mtgg=G'tzz
imap <C-f> <ESC><C-f>

" Ctrl-s saves file
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a
imap <c-s> <Esc><c-s>

function! CurDir()
  return substitute(getcwd(), '/Users/sergi/', "~/", "g")
endfunction

" Format the statusline
"set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ %l/%L\ %{fugitive#statusline()}

"statusline setup
set statusline =%#identifier#
set statusline+=[%t] "tail of the filename
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

"modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2

let maplocalleader = "\\"

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

"find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)
    let line_lens = map(getline(1,'$'), 'len(substitute(v:val, "\\t", spaces, "g"))')
    return filter(line_lens, 'v:val > threshold')
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

au BufEnter *.ml setf ocaml
au BufEnter *.mli setf ocaml
au FileType ocaml call FT_ocaml()
function FT_ocaml()
    set textwidth=80
    set colorcolumn=80
    set shiftwidth=2
    set tabstop=2
    " ocp-indent with ocp-indent-vim
    let opamshare=system("opam config var share | tr -d '\n'")
    execute "autocmd FileType ocaml source".opamshare."/vim/syntax/ocp-indent.vim"
    filetype indent on
    filetype plugin indent on
endfunction

" Use ag over grep
set grepprg=ag\ --nogroup\ --nocolor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"let g:ctrlp_user_command = "find %s -type f | egrep -v '/\.(git|hg|svn)|solr|tmp/' | egrep -v '\.(png|exe|jpg|gif|jar|class|swp|swo|log|gitkep|keepme|so|o)$'"
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_max_files=0

au BufNewFile,BufRead *.pml set filetype=xml
au BufRead,BufNewFile *.pml setlocal spell
autocmd filetype pml call AutoCorrect()
iab JAvaScript JavaScript

" Omni Completion settings
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" Blacklist pml files for YCM
let g:ycm_filetype_blacklist = { 'pml': 1 }

let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
nmap <Leader>\ :TlistToggle<CR>

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
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

"Also run the following line in vim to index the documentation:
:execute "helptags " . g:opamshare . "/merlin/vim/doc"
let g:syntastic_ocaml_checkers = ['merlin']

if $TMUX == ''
  set clipboard+=unnamed
endif
" Toggle Paste mode
noremap <silent> <leader>o :set paste!<CR>

au BufNewFile,BufRead *.pml set filetype=json
let g:syntastic_racket_code_ayatollah_script = '/Users/sergi/.vim/code-ayatollah.rkt'

" More granular undo (undo step after each space)
imap <Space> <Space><C-G>u
