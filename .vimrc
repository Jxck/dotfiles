" 構文チェック
syntax enable
" 折り返さない
set nowrap
" ラインナンバー表示
set number
" スクロールで見える範囲を増やす
set scrolloff=10
" ビープをならさない
set vb t_vb=
set novisualbell
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
" バックスペースで各種消せるように
set backspace=indent,eol,start
" タイトル表示
set title
" モードラインを有効に
set modeline
" ステータスライン
set laststatus=2
" メッセージ表示欄
set cmdheight=2
" 行/列番号の表示
set ruler
" 移動時に行頭に移動しない
set nostartofline
" 勝手に折り返さない
set textwidth=0
set formatoptions=q
" 外部で変更時自動読み込み
set autoread
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" IME
set iminsert=0
set imsearch=0
set imdisable

" 検索
" 大文字小文字を無視
set ignorecase
" その上で大文字を含めるとその通りに検索
set smartcase
" インクリメンタルサーチ
set incsearch
" 検索結果のハイライト
set hlsearch
" 検索が終わっても先頭に戻らない
set nowrapscan
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" /{pattern}の入力中は '/' をタイプすると自動で '\/'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" ?{pattern}の入力中は '?' をタイプすると自動で '\?'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

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
set encoding=utf-8
set termencoding=utf-8

" ヤンクした文字は、システムのクリップボードに入れる
" mac + tmux では tmux-MacOSX-pasteboard が必要
if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" 不可視文字表示
set list
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:<

" 全角スペースの表示
highlight SpecialKey cterm=underline ctermfg=lightblue guibg=darkgray
highlight JpSpace cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
match ZenkakuSpace /　/

" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=3

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

" {} 折りたたみ
" zo 折りたたみを展開
nnoremap zp zfa{

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
" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on

" Paste Mode
set pastetoggle=<F9>

" NeoBundle
if has('vim_starting')
   " 初回起動時のみ runtimepath に neobundle のパスを指定する
   set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

" NeoBundle を初期化
call neobundle#begin(expand('$HOME/.vim/bundle/'))

" NeoBundle 自体は git submodule で管理
"" NeoBundle 自体を NeoBundle で管理
"" NeoBundleFetch 'Shougo/neobundle.vim'

" インストールするプラグインをここに記述
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'ekalinin/Dockerfile.vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'tmux-plugins/vim-tmux'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'majutsushi/tagbar'

call neobundle#end()


" ejs は html モード
autocmd BufNewFile,BufRead *.ejs set ft=html
" md は markdown モード
autocmd BufNewFile,BufRead *.md set ft=markdown
" md は折り返す
autocmd BufNewFile,BufRead *.md set wrap
" zsh は zsh mode
autocmd BufNewFile,BufRead *.zsh set ft=zsh
" .tmux.conf は tmux mode
autocmd BufNewFile,BufRead .tmux.conf set ft=tmux
" go は go mode
autocmd BufNewFile,BufRead *.go set ft=go
autocmd BufNewFile,BufRead *.go set nolist
" go のファイルは保存時に自動 fmt
" autocmd BufWritePre *.go Fmt
" cr (crystal) は ruby モード
autocmd BufNewFile,BufRead *.cr set ft=ruby
" js でも jxc モード
let g:jsx_ext_required = 0

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

  " JS のテンプレート
  autocmd BufNewFile *.js 0r $HOME/.vim/template/index.js

  " JS Test のテンプレート
  autocmd BufNewFile test-*.js 0r $HOME/.vim/template/test.js
augroup END

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
autocmd CursorHold * wall
set updatetime=100

" カラーテーマ
syntax enable
colorscheme desert
highlight Search ctermfg=Black ctermbg=Red cterm=NONE

" grep
autocmd QuickFixCmdPost *grep* cwindow

" netrw
let g:netrw_sort_sequence='[\/]$,[|],[=],[\@],[*],^[\.]'
let g:netrw_special_syntax=1
hi netrwDir     ctermfg=4
hi netrwTmp     ctermfg=4
hi netrwSymLink ctermfg=6
hi netrwExe     ctermfg=1
