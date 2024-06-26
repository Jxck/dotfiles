""""""""""""""""""""""""""""""
" Basic
""""""""""""""""""""""""""""""
" vi 互換を無効に
set nocompatible
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
" 自動セーブ
autocmd CursorHold * wall
set updatetime=100
" 外部で変更時自動読み込み
set autoread
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END
" ヤンクした文字は、システムのクリップボードに入れる
" mac + tmux では tmux-MacOSX-pasteboard が必要
if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" Paste Mode
set pastetoggle=<F9>


""""""""""""""""""""""""""""""
" Text
""""""""""""""""""""""""""""""
" 文字コード(EUC を追加)
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,ucs-bom,default,latin1
set encoding=utf-8
set termencoding=utf-8

" IME
set iminsert=0
set imsearch=0
set imdisable

" 不可視文字表示
set list
set listchars=tab:__,trail:_,nbsp:_,extends:>,precedes:<

" 全角スペースの表示
highlight SpecialKey   cterm=underline ctermfg=lightblue guibg=darkgray
highlight JpSpace      cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
match ZenkakuSpace /　/

" 対応括弧に < と > のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=3

" C-g * 2 でハイライトオフ
nmap <C-g><C-g> :nohlsearch<CR><Esc>

" vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88


""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""
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

nnoremap n nzz
nnoremap N Nzz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" /{pattern}の入力中は '/' をタイプすると自動で '\/'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" ?{pattern}の入力中は '?' をタイプすると自動で '\?'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" grep
autocmd QuickFixCmdPost *grep* cwindow


""""""""""""""""""""""""""""""
" Move
""""""""""""""""""""""""""""""
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" 移動関連
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <UP>
inoremap <C-d> <Delete>
inoremap <C-j> <ESC>

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

" リサイズ
"下 Ctrl-E + j
"上 Ctrl-E + k
"左 Ctrl-E + h
"右 Ctrl-E + l
nnoremap <C-E><C-k> :resize -3<CR>
nnoremap <C-E><C-j> :resize +3<CR>
nnoremap <C-E><C-h> :vertical resize +10<CR>
nnoremap <C-E><C-l> :vertical resize -10<CR>

" タブ操作
map <C-t><C-o> :tabnew<CR>
map <C-t><C-c> :tabclose<CR>
map <C-t><C-n> :tabnext<CR>
map <C-t><C-p> :tabprevious<CR>

" netrw
let g:netrw_sort_sequence='[\/]$,[..]$,[\*]$,[\@]$,*'
let g:netrw_special_syntax=1
highlight netrwDir     ctermfg=4
highlight netrwTmp     ctermfg=4
highlight netrwSymLink ctermfg=6
highlight netrwExe     ctermfg=1

command! E Explore


""""""""""""""""""""""""""""""
" File Type
""""""""""""""""""""""""""""""
" インデント関連
set smartindent
set autoindent
set shiftwidth=2

" カラーテーマ
syntax enable
colorscheme default
highlight Search ctermfg=Black ctermbg=Red cterm=NONE

" 諸々有効に
filetype on
filetype plugin on
filetype plugin indent on

" mjs は javascript モード
autocmd BufNewFile,BufRead *.mjs set ft=javascript

" ejs は html モード
autocmd BufNewFile,BufRead *.ejs set ft=html

" slim は slim モード
autocmd BufNewFile,BufRead *.slim set ft=slim
autocmd BufNewFile,BufRead *.scss set tabstop=4

" scss は scss モード
autocmd BufNewFile,BufRead *.scss set ft=scss
autocmd BufNewFile,BufRead *.scss set tabstop=4

" md は markdown モード
autocmd BufNewFile,BufRead *.md set ft=markdown
" md で fold しない
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['js=javascript']

" zsh は zsh mode
autocmd BufNewFile,BufRead *.zsh set ft=zsh

".tmux.conf は tmux mode
autocmd BufNewFile,BufRead *.tmux.conf set ft=tmux

" h2o.*.conf は conf mode
autocmd BufNewFile,BufRead h2o.*.conf set ft=conf

" nginx.conf は nginx mode
autocmd BufNewFile,BufRead nginx.conf set ft=nginx

" .service は systemd mode
autocmd BufNewFile,BufRead *.service set ft=systemd

" .textlintrc は json
autocmd BufNewFile,BufRead *textlintrc set ft=json

" .log は AnsiEsc
autocmd BufNewFile,BufRead *log :AnsiEsc

" .idtag は html
autocmd BufNewFile,BufRead *idtag set ft=html

" go は go mode
autocmd BufNewFile,BufRead *.go set ft=go
autocmd BufNewFile,BufRead *.go set nolist
" go のファイルは保存時に自動 fmt
" autocmd BufWritePre *.go Fmt
" go-run の実行
au FileType go nmap <leader>r <Plug>(go-run)

" cr (crystal) は ruby モード
autocmd BufNewFile,BufRead *.cr set ft=ruby

" app は erlang モード
augroup Erlang
  autocmd!
  autocmd BufNewFile,BufRead *.app setlocal ft=erlang
  autocmd BufNewFile,BufRead *.erl setlocal ft=erlang expandtab shiftwidth=4
augroup END

" tsx は tsx モード
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" obsidian/config は json モード
autocmd BufNewFile,BufRead .obsidian/config set filetype=json

" js でも jsx モード
let g:jsx_ext_required = 0

" json のダブルクオテーションを表示
let g:vim_json_syntax_conceal = 0

" テンプレート
augroup template-file
  autocmd!

  " Erlang のテンプレート
  function! s:ReadErlTemplate(name)
    if a:name =~# '_SUITE.erl'
      " erlang ct SUITE のテンプレート
      0r $HOME/.vim/template/SUITE.erl
    elseif a:name =~# '_statem.erl'
      " erlang gen_statem のテンプレート
      0r $HOME/.vim/template/gen_statem.erl
    elseif a:name =~# '_server.erl'
      " erlang gen_server のテンプレート
      0r $HOME/.vim/template/gen_server.erl
    else
      " erlang のテンプレート
      0r $HOME/.vim/template/main.erl
    endif
  endfunction
  autocmd BufNewFile *.erl call <SID>ReadErlTemplate(expand('%'))

  " Go のテンプレート
  function! s:ReadGoTemplate(name)
    if a:name =~# '_test.go'
      0r $HOME/.vim/template/test.go
    else
      0r $HOME/.vim/template/main.go
    endif
  endfunction
  autocmd BufNewFile *.go call <SID>ReadGoTemplate(expand('%'))

  " shell のテンプレート
  autocmd BufNewFile *.sh 0r $HOME/.vim/template/test.sh

  " markdown のテンプレート
  autocmd BufNewFile *.md 0r $HOME/.vim/template/README.md

  " HTML のテンプレート
  autocmd BufNewFile *.html 0r $HOME/.vim/template/index.html

  " JS のテンプレート
  autocmd BufNewFile *.js 0r $HOME/.vim/template/index.js

  " JS Test のテンプレート
  autocmd BufNewFile test-*.js 0r $HOME/.vim/template/test.js

  " JSX のテンプレート
  autocmd BufNewFile *.jsx 0r $HOME/.vim/template/index.jsx

  " Ruby のテンプレート
  autocmd BufNewFile *.rb 0r $HOME/.vim/template/index.rb
augroup END

" vim-go
let g:go_highlight_functions         = 1
let g:go_highlight_methods           = 1
let g:go_highlight_structs           = 1
let g:go_highlight_interfaces        = 1
let g:go_highlight_operators         = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command                 = "goimports"


""""""""""""""""""""""""""""""
" Short Cut
""""""""""""""""""""""""""""""
" インクリメントを + に
nnoremap + <C-a>
" デクリメントを - に
nnoremap - <C-x>
" プラスは Shift いるけど
" マイナスは Shift いらないので
" Shift がいる _ もデクリメントに
nnoremap _ <C-x>

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

" Jq
command! Jq %!jq '.'

" Leader
let mapleader = "\<Space>"
nmap <Leader>1 :!singler   %<CR>
nmap <Leader>2 :!spacer    %<CR>
nmap <Leader>3 :!format.rb %<CR>
nmap <Leader>v :<C-u>setlocal cursorline! cursorcolumn!<CR>
nmap <Leader>r :source ~/.vimrc<CR>

" q で macro record が始まるのがうざいので Leader + q にする
" 必ず @a に保存し Leader + w で実行する
noremap <Leader>q qa
noremap <Leader>w q
noremap <Leader>e @a
noremap q <Nop>

" vim-easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
vmap <Enter> <Plug>(EasyAlign)
