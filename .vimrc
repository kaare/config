" pathogen plugin
call pathogen#runtime_append_all_bundles()

" some ideas stolen from http://items.sjbach.com/319/configuring-vim-right
set history=1000
"
" buffer stuff
set hidden

runtime macros/matchit.vim

set title

" folding 
set foldcolumn=3

" scrolling and viewport
nnoremap <C-e> 40<C-e>
nnoremap <C-y> 40<C-y>
set scrolloff=3

set ruler

nnoremap ' `
nnoremap ` '

" general stuff

syntax on
filetype on
filetype plugin on
filetype indent on

" visual bell
set vb


set autoindent
" set textwidth=78
set backspace=indent,eol,start

set tabstop=4
" set expandtab
set shiftwidth=4
set shiftround

set matchpairs+=<:>

iab phdr #!/usr/bin/env perl<CR><CR>use 5.010;<CR>use strict;<CR>use warnings;<CR>
iab pdbg use Data::Dumper 'Dumper';<CR>$Data::Dumper::Maxdepth = 4;<CR>warn Dumper([ ]), ' ';<ESC>$8hi

map <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
map <F3> :source ~/vim_session <cr>     " And load session with F3

" Searching
set ignorecase   
set smartcase         " don't ignore case if there's a uppercase
set incsearch         " show me right now!
set hlsearch

" TList
nnoremap <silent> <F8> :Tlist<CR>

" TagExplorer
let TE_Ctags_Path = 'exuberant-ctags'
nnoremap <silent> <F7> :TagExplorer<CR>

" NerdTree
nnoremap <silent> <F9> :NERDTree<CR>


" backup stuff
set backup
set writebackup
set   backupdir=/tmp/vim/
set   directory=/tmp/vim/
" set   backupdir=~/.vim/backup,./.backup,~/.vim/backup,.,/tmp
" set   directory=~/.vim/backup,.,./.backup,/tmp

function InsertTabWrapper()
   let col = col('.') - 1
   if !col || getline('.')[col - 1] !~ '\k'
       return "\<tab>"
   else
       return "\<c-p>"
   endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" cute ai toggle
map ,<TAB> :set ai!<CR>:set ai?<CR>

" comment delimiters
map ,~ i#<ESC>59a~<ESC>o<ESC>
map ,# 60i#<ESC>o<ESC>


let mapleader = ","


"autocmd FileType perl source ~/.vim/my/perl_map.vim
"autocmd FileType perl map ,~ i3<ESC>59a~<ESC>o<ESC>
"autocmd FileType perl map ,3 60i3<ESC>o<ESC>

" Perl stuff

let g:Perl_AuthorName      = 'Kaare Rasmussen'
let g:Perl_AuthorRef       = 'KAARE'
let g:Perl_Email           = 'kaare@cpan.org'
let g:Perl_Company         = 'Jasonic'

let tlist_perl_settings  = 'perl;c:constants;l:labels;p:package;s:subroutines;d:POD'

" taken from http://use.perl.org/~Ovid/journal/33567
fun! TestClassRunThisMethod()
    let save_cursor=getpos('.')
    let SAVE_TEST_METHOD=$TEST_METHOD

    call search('^sub \+\zs.*:.*Test','bcW')
    let $TEST_METHOD = expand('<cword>')
    exe '!printenv | sort'

    let $TEST_METHOD=SAVE_TEST_METHOD
    call setpos('.', save_cursor)
endfun

nnoremap <expr> ,tm TestClassRunThisMethod()

" ack for grep
set grepprg=ack\ --nocolor\ --nogroup\ '$*'\ *\ /dev/null
nmap <C-v><C-n> :cnext<CR>
imap <C-v><C-n> <Esc><C-v><C-n>
nmap <C-v><C-p> :cprev<CR>
imap <C-v><C-p> <Esc><C-v><C-p>

" begone, vile HTML indentation
autocmd BufEnter *.html setlocal indentexpr= 

set complete=.,w,b,u,t " omits ',i'. This avoids full file scans.

" ================= colorscheme ==============================
" gui
set t_Co=256
"let g:zenburn_high_Contrast = 1
"hi search ctermbg=223 ctermfg=238
"hi incsearch ctermbg=216 ctermfg=242
if ! has("gui_running")
    set t_Co=256
endif
" feel free to choose :set background=light for a different style
set background=dark
colors peaksea

nnoremap <Leader>l :call LoadPerlModule()<CR>

function! LoadPerlModule()
    let a:module_name = substitute(expand("<cWORD>"), ',', '', 'g')
    execute 'e `perldoc -l ' . a:module_name  . '`'
endfunction

function! PerlMappings()
    " run the code
    noremap <buffer> <leader>r :!perl %<cr>
 
    " or check that it compiles
    noremap <buffer> <leader>r :!perl -c %<cr>
 
    " or run tall of the tests for it
    noremap <buffer> <leader>t :call TestModuleCoverage()<cr>
endfunction
 
function! PerlTestMappings()
    noremap <buffer> <leader>r :!prove -vl %<cr>
 
    " or check that it compiles
    noremap <buffer> <leader>r :!perl -c %<cr>
 
    noremap <buffer> <leader>t :!prove -vl %<CR>
endfunction
 
function! TestModuleCoverage()
    let filename = bufname('%')
 
    let tests = system('covered covering --source_file="'. filename .'"')
 
    let result  = split( tests, "\n" )
 
    if empty(result)
        echomsg "No tests found for: ". filename
    else
        execute ':!prove  ' . join(result)
    endif
endfunction

au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove

au BufRead,BufNewFile entry* set filetype=galuga

map ,rf <Esc>:'<,'>! ~/bin/extract_perl_sub.pl<CR>
"let g:solarized_termcolors=256
"colorscheme solarized

" Simplenote
let g:SimplenoteUsername = "kaare@jasonic.dk"
let g:SimplenotePassword = "******"

set clipboard=unnamedplus
