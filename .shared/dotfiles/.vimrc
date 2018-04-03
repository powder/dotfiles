" Safeguard against me being an idiot and defining autocmds incorrectly.
autocmd!

" Load any .before files before plugins have been loaded and options set.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

"Vim-Plug Setup
call plug#begin('~/.vim/plugged')

  " Colorscheme
  Plug 'NLKNguyen/papercolor-theme'

  " Search files, folders, and content fast.
  Plug 'kien/ctrlp.vim'
  Plug 'FelikZ/ctrlp-py-matcher'
  Plug 'nixprime/cpsm'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Tag Management and dependencies
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-easytags'
  Plug 'majutsushi/tagbar'

  " Show git differences.
    Plug 'mhinz/vim-signify'

  " Alignment and tabs.
  Plug 'tommcdo/vim-lion'
  Plug 'godlygeek/tabular'

  " Nerdtree
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " Deroplete
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'uplus/deoplete-solargraph'

  " Ruby and Rails completion sources
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'osyo-manga/vim-monster'

  " Syntax checker
  Plug 'vim-syntastic/syntastic'

  " Using deoplete instead
  " Plug 'Valloric/YouCompleteMe'

call plug#end()

" Deoplete.vim configuration and startup.
let g:python3_host_prog = '/Users/powder/.asdf/shims/python3'
let g:deoplete#enable_at_startup = 1

" vim-monster deoplete integration settings
"let g:monster#completion#rcodetools#backend = "async_rct_complete"
let g:monster#completion#solargraph#backend = "async_solargraph_suggest"
let g:deoplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}

" Vim Settings
" ------------
" Disable classic vi emulation
set nocompatible

" Appearance related settings
colorscheme PaperColor
set t_Co=256
set background=dark

" Add ** to path so that wildmenu populates with project files
set path+=**

" Enable wildcard menu
set wildmenu

" Configure backspace behavior
set backspace=indent,eol,start

" Do not wrap lines
set nowrap
set tw=0

" Set column 80 to be colored
set colorcolumn=80

" Set hidden, allowing windows to have hidden edits
set hidden

" Show line numbers
set number

" Show cursor positioning
set ruler

" Make tab and eol characters visible
set listchars=tab:▸\ ,eol:¬

" Tabstop, softtabstop, and shiftwidth set to 2 + expand tabs into spaces
set ts=2 sw=2 expandtab

" Smmoth redraw assuming a fast terminal and connection
set ttyfast

if has("autocmd")
  " Enable filetype indentation rules
  if version > 600
    filetype plugin indent on
  else
    filetype on
  endif

  syntax enable

  " Auto-reload any changes to .vimrc after writing the file.
  autocmd bufwritepost .vimrc source $MYVIMRC

  augroup ruby_xmpfilter
    autocmd FileType ruby nmap <buffer> <leader>m <Plug>(xmpfilter-mark)
    autocmd FileType ruby xmap <buffer> <leader>m <Plug>(xmpfilter-mark)
    autocmd FileType ruby imap <buffer> <leader>m <Plug>(xmpfilter-mark)

    autocmd FileType ruby nmap <buffer> <leader>r <Plug>(xmpfilter-run)
    autocmd FileType ruby xmap <buffer> <leader>r <Plug>(xmpfilter-run)
    autocmd FileType ruby imap <buffer> <leader>r <Plug>(xmpfilter-run)
  augroup END

  augroup nerdtree_settings
    " autocmd vimenter * NERDTree | if (len(getbufinfo({'buflisted':1}))) == 1 | wincmd l | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

  augroup block_commenting_styles
    autocmd Filetype zshrc            let b:comment_leader = '# '
    autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
    autocmd FileType sh,ruby,python   let b:comment_leader = '# '
    autocmd FileType conf,fstab       let b:comment_leader = '# '
    autocmd FileType vim              let b:comment_leader = '" '

    noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
  augroup END
endif

" CtrlP settings that increase speed of matching
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$\|tmp$\|doc$'
let g:ctrlp_follow_symlinks = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

" Easytag configuration (Needs Review)
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
noremap ,e :e $MYVIMRC<CR>|                       " edit $MYVIMRC
noremap ,u :source $MYVIMRC<CR>|                  " source $MYVIMRC
nnoremap <leader>, :tabe $MYVIMRC<CR>|            " tabedit $MYVIMRC

" Toggle listchars
nnoremap <leader>l :set list!<CR>|                " Toggle listchars
inoremap <leader>l :set list!<CR>|                " Toggle listchars

" Force write on protected files
cmap WW w !sudo tee 1>/dev/null %<CR>l<CR>

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

fun! StripTrailingWhitespace()
    if &filetype =~ 'python\|perl'
        return
    endif
    %s/\s\+$//e
endfun

" Call on Filewrite
autocmd BufWritePre * call StripTrailingWhitespace()

" Call on mapping invocation
noremap <silent> <C-a> <Esc>:call StripTrailingWhitespace()<CR>

" Load any .after files after plugins have been loaded and options set.
if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif


