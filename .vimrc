set number                       " ラインナンバー表示
set expandtab                    " タブをスペースに
set tabstop=2                    " タブを 2 スペースに
set noswapfile                   " スワップファイルなし
set nobackup                     " バックアップファイルなし
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set vb t_vb=                     " ビープをならさない
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
"set clipboard=unnamed,autoselect " ヤンクした文字は、システムのクリップボードに入れる
set paste                        " ペースト時にautoindentを無効にする

set smartindent
filetype indent on
set shiftwidth=2

" 不可視文字表示
set list
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:<

" 全角スペースの表示
highlight SpecialKey cterm=underline ctermfg=lightblue guibg=darkgray
highlight JpSpace cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
au BufRead,BufNew * match ZenkakuSpace /　/


autocmd BufNewFile,BufRead *.ejs set ft=html " ejs は html モード

" インサートモードでも Ctl + npbf で移動
imap <C-n> <Down>
imap <C-p> <Up>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-d> <delete>

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up> gk

" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

autocmd CursorHold * update
set updatetime=500

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

colorscheme desert
