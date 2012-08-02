" ラインナンバー表示
set number
" ビープをならさない
set vb t_vb=
" タブをスペースに
set expandtab
" タブを 2 スペースに
set tabstop=2
" スワップファイルなし
set noswapfile
" バックアップファイルなし
set nobackup
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" 不可視文字表示
set list
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:<

" 全角スペースの表示
highlight SpecialKey cterm=underline ctermfg=lightblue guibg=darkgray
highlight JpSpace cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
match ZenkakuSpace /　/

" 移動関連
inoremap <C-a>  <Home>
inoremap <C-e>  <End>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-n>  <Down>
inoremap <C-p>  <UP>
inoremap <C-d>  <Delete>
inoremap jj <ESC>

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up> gk

" インデント関連
set smartindent
set autoindent
filetype plugin on
filetype indent on

" ejs は html モード
autocmd BufNewFile,BufRead *.ejs set ft=html
" md は markdown モード
autocmd BufNewFile,BufRead *.md set ft=markdown

" CCD
command! -nargs=? -complete=dir -bang CCD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" 自動セーブ
autocmd CursorHold * update
set updatetime=100

" カラーテーマ
colorscheme elflord
