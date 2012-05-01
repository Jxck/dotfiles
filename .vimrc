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
set clipboard=unnamed            " ヤンクした文字は、システムのクリップボードに入れる

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

set list                         " 不可視文字表示
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:< " 不可視文字の表示形式

" インサートモードでも Ctl + hjkl で移動
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up> gk

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
