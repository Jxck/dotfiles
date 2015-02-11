" 折り返さない
set nowrap
" ラインナンバー表示
set number
" ビープをならさない
set vb t_vb=
" タブをスペースに
set expandtab
" タブを 2 スペースに
set tabstop=2
" 全角記号を全角幅で
set ambiwidth=double
" スワップファイルなし
set noswapfile
" バックアップファイルなし
set nobackup
" アンドゥファイルなし
set noundofile
" 検索の大/小文字をいい感じに
set smartcase
" 勝手に折り返さない
set textwidth=0
set formatoptions=q
" 外部で変更時自動読み込み
set autoread
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" インクリメントを + に
nnoremap + <C-a>
" デクリメントを - に
nnoremap - <C-x>
" プラスは Shift いるけど
" マイナスは Shift いらないので
" Shift がいる _ もデクリメントに
nnoremap _ <C-x>

" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 文字コード(EUC を追加)
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,ucs-bom,default,latin1

" ヤンクした文字は、システムのクリップボードに入れる
" mac + tmux では tmux-MacOSX-pasteboard が必要
set clipboard=unnamed

" 不可視文字表示
set list
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:<

" 全角スペースの表示
highlight SpecialKey cterm=underline ctermfg=lightblue guibg=darkgray
highlight JpSpace cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
match ZenkakuSpace /　/

" C-g * 2 でハイライトオフ
nmap <C-g><C-g> :nohlsearch<CR><Esc>

" 移動関連
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <UP>
inoremap <C-d> <Delete>
inoremap <C-j> <ESC>

" リサイズ
"下 Ctrl-E + j
"上 Ctrl-E + k
"左 Ctrl-E + h
"右 Ctrl-E + l
nnoremap <C-E><C-k> :resize -3<CR>
nnoremap <C-E><C-j> :resize +3<CR>
nnoremap <C-E><C-h> :vertical resize +10<CR>
nnoremap <C-E><C-l> :vertical resize -10<CR>

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up> gk

" コマンドライン関連
" 先頭に移動
cnoremap <C-a> <Home>
" 一文字戻る
cnoremap <C-b> <Left>
" カーソルの下の文字を削除
cnoremap <C-d> <Del>
" 行末へ移動
cnoremap <C-e> <End>
" 一文字進む
cnoremap <C-f> <Right>
" コマンドライン履歴を一つ進む
cnoremap <C-n> <Down>
" コマンドライン履歴を一つ戻る
cnoremap <C-p> <Up>
" 前の単語へ移動
cnoremap <M-b> <S-Left>
" 次の単語へ移動
cnoremap <M-f> <S-Right>

" インデント関連
set smartindent
set autoindent
set shiftwidth=2
filetype plugin on
filetype indent on

" Paste Mode
set pastetoggle=<C-k>

" Go のプラグイン
set rtp+=$GOROOT/misc/vim

" ejs は html モード
autocmd BufNewFile,BufRead *.ejs set ft=html
" md は markdown モード
autocmd BufNewFile,BufRead *.md set ft=markdown
" md は折り返す
autocmd BufNewFile,BufRead *.md set wrap
" dotfiles/zsh/* は zsh mode
autocmd BufNewFile,BufRead $HOME/dotfiles/zsh/* set ft=zsh
" .tmux.conf は tmux mode
autocmd BufNewFile,BufRead .tmux.conf set ft=tmux
" go は go mode
autocmd BufNewFile,BufRead *.go set ft=go
" go のファイルは保存時に自動 fmt
autocmd BufWritePre *.go Fmt

" テンプレート
augroup template-file
  autocmd!

  " Go のテンプレート
  function! s:ReadGoTemplate(name)
    if a:name =~# '_test.go'
      0r $HOME/.vim/template/test.go
    else
      0r $HOME/.vim/template/main.go
    endif
  endfunction
  autocmd BufNewFile *.go call <SID>ReadGoTemplate(expand('%'))

  " README.md のテンプレート
  autocmd BufNewFile README.md 0r $HOME/.vim/template/README.md

  " HTML のテンプレート
  autocmd BufNewFile *.html 0r $HOME/.vim/template/index.html
augroup END

" 折り畳み
set foldmethod=syntax
set foldlevelstart=1
let javaScript_fold=1

" 自動セーブ
autocmd CursorHold * wall
set updatetime=100

" カラーテーマ
colorscheme desert

" grep
autocmd QuickFixCmdPost *grep* cwindow
