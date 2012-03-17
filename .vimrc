set number                       " ラインナンバー表示
set expandtab                    " タブをスペースに
set tabstop=2                    " タブを 2 スペースに
set backupdir=$HOME/.vimbackup   " バックアップディレクトリ
set directory=$HOME/.vimbackup   " スワップディレクトリ
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set vb t_vb=                     " ビープをならさない
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
"set clipboard=unnamed            " ヤンクした文字は、システムのクリップボードに入れる

set list                         " 不可視文字表示
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:< " 不可視文字の表示形式

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/


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
