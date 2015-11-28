" -=- Welcome to my Vim config -=-

" **************** First things first: Some general configuration

set nocompatible                                              " Turn off vi-compatibility, must be the first config to set
filetype on
filetype plugin indent on

let mapleader = ','                                           " <Leader> is ','

set encoding=utf-8
set ai                                                        " Automatically set the indent of a new line (local to buffer)
set completeopt=longest,menu                                  " Only show completion menu for more then one option and use the longest common text
set timeout timeoutlen=1000 ttimeoutlen=100                   " Fix slow O inserts from Gary Bernhardt
set shell=/bin/sh                                             " some commands seem to have problems with zsh (i.e. RVM)
set nowrap                                                    " There should be no wrapping (at least not for source code).
set sidescroll=1                                              " Scroll 1 column at a time horizontally
set sidescrolloff=2                                           " Keep some columns left/right for sidescrolling
set equalalways                                               " Multiple windows, when created, are equal in size
set splitbelow splitright                                     " Define where new splits should be placed
set cursorline                                                " Highlight the line with the cursor
set hlsearch                                                  " highlight search
set incsearch                                                 " Incremental search, search as you type
set ignorecase smartcase                                      " Ignore case when searching
set ruler                                                     " Show the current line and column number
set showmode                                                  " Display the mode you're in.
set scrolloff=3                                               " Show 3 lines of context around the cursor.
set ttyfast                                                   " We got us a fast terminal (a.k.a. local machine)
set backspace=indent,eol,start                                " Intuitive backspacing.
set nonumber                                                  " Hide line numbers per default
set list listchars=trail:·,tab:>-,nbsp:¬,extends:»,precedes:« " Show invisble chars and tell how to display them
set nobackup                                                  " Don't make a backup before overwriting a file.
set nowritebackup                                             " And again.
set noswapfile                                                " Don't use swapfiles
set hidden                                                    " Handle multiple buffers better.
set laststatus=2                                              " Show the status line all the time
set title                                                     " Set the terminal's title
set clipboard=unnamed                                         " Copy to system pasteboard
set winwidth=79                                               " Try to make the current window this wide
set mouse=n                                                   " Scrolling with the Magic Trackpad is just too nice ;-)
set wildmenu                                                  " Enhanced command line completion.
set wildmode=list:longest,list:full                           " And how to complete on the command line
set nofoldenable                                              " Turn on folding
set foldmethod=syntax                                         " Folding based on syntax
set foldlevel=1                                               " Close all folds starting with the first
set spell spelllang=en_us                                     " Activate spell checking and set American as default

" Some files we just don't want to see here
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,tmp/*,*.so,*.swp,*.zip " general stuff
set wildignore+=*.png,*.jpg,*.gif,*.jpeg " images
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,Gemfile.lock,*/log/*,.sass-cache,*/coverage/* " Ruby related files
set wildignore+=*.pyc,*.pyo " Python
set wildignore+=*/node_modules/****************" " NodeJS

" :w!! to save with sudo
cmap w!! w !sudo tee % > /dev/null

" Enable auto-save / auto-write
set autowrite
set autowriteall
au BufLeave,FocusLost * silent! :wa

" Setup color scheme
syntax enable                                    " Enable syntax highlighting
set background=dark                              " Me like it dark
colorscheme pinkiepie                            " And me like it pink
match ErrorMsg '\%>100v.\+'                      " Highlight Characters that overstep 100 characters (via @moonglum)
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$' " Highlight VCS conflict markers


" **************** And now for some custom mappings

" Center display line after each search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Vertical and horizontal split then hop to a new buffer
noremap <Leader>v :vsp<cr>
noremap <Leader>h :split<cr>

" Clear the search highlighting
nnoremap <leader><cr> :nohlsearch<CR>
" Easier switching between previous and current buffer
nnoremap <leader><leader> <c-^>

" Toggle folding with <Space>
nnoremap <Space> za
vnoremap <Space> zf

" Make cursor move by visual lines instead of file lines (when wrapping)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Resize splits with home H/J/K/L
map <S-Left> :vertical res +5<CR>
map <S-Right> :vertical res -5<CR>
map <S-Up> :res +5<CR>
map <S-Down> :res -5<CR>

" Move between splits
map <C-S-Left> <C-w><Left>
map <C-S-Right> <C-w><Right>
map <C-S-Up> <C-w><Up>
map <C-S-Down> <C-w><Down>

" upper/lower word
nmap <leader>L gUiw
nmap <leader>l guiw

" Adjust viewports to the same size
map <Leader>= <C-w>=
imap <Leader>= <Esc> <C-w>=i

" **************** Custom functions

function! s:setupFourSpacesIndent()
  set softtabstop=4 shiftwidth=4 tabstop=4
  set noexpandtab|retab
endfunction

function! s:setupTwoSpacesIdent()
  set softtabstop=2 shiftwidth=2 tabstop=2
  set smarttab
  set expandtab|retab
endfunction

" Two spaces indent is default
call s:setupTwoSpacesIdent()

" Remove trailing spaces
function RemoveTrailingSpaces()
  %s/\v[\t ]{-1,}$//g
endfunction
" And create a command for it
command Rts :call RemoveTrailingSpaces()

" **************** Here be autocommands

" Open all folds automatically
autocmd BufRead,BufNewFile * normal zR

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  "Sourced from vim tip: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
  autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
  autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType ruby,javascript set synmaxcol=800
  autocmd FileType python setlocal sw=4 sts=4 noexpandtab

  autocmd! BufRead,BufNewFile *.sass setfiletype sass
  autocmd! BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

  " md, markdown, and mk are markdown and define buffer-local preview
  autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
  autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ft=markdown ai formatoptions=tcroqn2 comments=n:&gt;

  autocmd FileType ruby compiler ruby
  autocmd FileType ruby set foldmethod=syntax
  autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

  " Makefiles require tabs
  autocmd FileType make setlocal noexpandtab

  " Omni Completion *************************************************************
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType c set omnifunc=ccomplete#Complete

  " May require ruby compiled in
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete

  " Set the Ruby filetype for a number of common Ruby files without .rb (via @moonglum)
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,Capfile,config.ru,*.rake,*.rabl} set ft=ruby

  " Syntax highlighting for JSON
  au BufNewFile,BufRead *.json set ft=javascript

  " Plain text should be wrapped too
  au BufRead,BufNewFile *.txt call s:setupForProse()
augroup END



" At the very end (and after Vundle is finished) re-activate file type detection
