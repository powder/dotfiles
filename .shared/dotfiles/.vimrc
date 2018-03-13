" Clear autocmds
autocmd!

" Load any before file, before loading other plugins
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" Plug setup

call plug#begin()
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'kien/ctrlp.vim'
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-syntastic/syntastic'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-easytags'
  Plug 'majutsushi/tagbar'
  Plug 'mhinz/vim-signify'
  Plug 'Shougo/neocomplete'
  Plug 'hwartig/vim-seeing-is-believing'
  Plug 'elixir-lang/vim-elixir'
  Plug 'SirVer/ultisnips'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'altercation/vim-colors-solarized'
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'tommcdo/vim-lion'
  Plug 'tpope/vim-repeat'
  Plug 'svermeulen/vim-easyclip'
  Plug 'itchyny/lightline.vim'
  Plug 'Shougo/unite.vim'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'tpope/vim-fugitive'
call plug#end()

" Disable classic vi emulation
set nocompatible

" Appearance related settings
colorscheme PaperColor
set t_Co=256
set background=dark

" Add ** to the path so that wildmenu populates with project files
set path+=**

" Enable the wildcard menu
set wildmenu

" Configure backspace
set backspace=indent,eol,start

" Do not wrap lines
set nowrap
set tw=0

" Set column 80 to be colored
set colorcolumn=80

" Set hidden, allow windows to have hidden edits
set hidden

" Make tab and eol characters visible
set listchars=tab:▸\ ,eol:¬

" Enable line numbers
set number

" Show cursor positioning
set ruler

" Tabstop, softtabstop, and shiftwidth set to 2 + expandtab
set ts=2 sts=2 sw=2 expandtab

" Smooth redraw assuming a fast terminal and connection
set ttyfast

" Configure autocmd blocks
if has("autocmd")
  if version > 600
    filetype plugin indent on
  else
    filetype on
  endif

  syntax on

  " Auto-reload any changes to .vimrc after writing the file.
  autocmd bufwritepost .vimrc source $MYVIMRC

  " Enable seeing-is-believing mappings only for Ruby
  augroup seeingIsBelievingSettings
    autocmd!

    autocmd FileType ruby nmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)
    autocmd FileType ruby xmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)

    autocmd FileType ruby nmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
    autocmd FileType ruby xmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
    autocmd FileType ruby imap <buffer> <leader>m <Plug>(seeing-is-believing-mark)

    autocmd FileType ruby nmap <buffer> <leader>r <Plug>(seeing-is-believing-run)
    autocmd FileType ruby imap <buffer> <leader>r <Plug>(seeing-is-believing-run)
  augroup END

  " Nerdtree Settings
  augroup nerdtree_settings
    autocmd vimenter * NERDTree | if (len(getbufinfo({'buflisted':1}))) == 1 | wincmd l | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

  " Block commenting
  augroup block_commenting_styles
    autocmd Filetype zshrc                  let b:comment_leader = '# '
    autocmd Filetype c,cpp,java,scala       let b:comment_leader = '// '
    autocmd Filetype sh,ruby,python         let b:comment_leader = '# '
    autocmd Filetype conf,fstab             let b:comment_leader = '# '
    autocmd Filetype vim                    let b:comment_leader = '" '

    noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader, '\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader, '\/')<CR>//e<CR>:nohlsearch<CR>
  augroup END
endif

" Easytag configuration (Review this later)
let g:easytags_async = 1
let g:easytags_always_enabled = 1
let g:easytags_on_cursorhold = 1
let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
      \ ]
    \ }

" Quick commands for editing $MYVIMRC
nnoremap ,e :e $MYVIMRC<CR>|                               " edit $MYVIMRC
nnoremap ,u :source $MYVIMRC<CR>|                          " source $MYVIMRC
nnoremap <leader>, :tabe $MYVIMRC<CR>

" \l to toggle listchars
nnoremap <leader>l :set list!<CR>

" Force write on protected files
cnoremap WW w !sudo tee 1>/dev/null %<CR>l<CR>

" Preserve, Strip Trailing Spaces, and Re-indent
" ------------------------------------------------
" http://vimcasts.org/episodes/tidying-whitespace/
" ------------------------------------------------
function! Preserve(command)
  let _s=@/
  let linenum = line(".")
  let colnum = col(".")

  execute a:command

  let @/=_s
  call cursor(linenum, colnum)
endfunction

nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nnoremap _= :call Preserve("normal gg=G")<CR>

" ------------------------------------------------

" StripTrailingWhiteSpace on file write
autocmd BufWritePre * call Preserve("%s/\\s\\+$//e")

" Move lines with alt-key presses
nnoremap <a-j> :m .+1<CR>==
nnoremap <a-k> :m .-2<CR>==
inoremap <a-j> <Esc>:m .+1<CR>==gi
inoremap <a-k> <Esc>:m .-2<CR>==gi
vnoremap <a-j> :m '>+1<CR>gv=gv
vnoremap <a-k> :m '<-2<CR>gv=gv

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
