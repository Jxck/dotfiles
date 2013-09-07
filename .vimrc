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
" 勝手に折り返さない
set textwidth=0
set formatoptions=q
" 外部で変更時自動読み込み
set autoread
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 文字コード(EUC を追加)
set fileencodings=iso-2022-jp,euc-jp,cp932,ucs-bom,utf-8,default,latin1

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

" ESC * 2 でハイライトオフ
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" 移動関連
inoremap <C-a>  <Home>
inoremap <C-e>  <End>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-n>  <Down>
inoremap <C-p>  <UP>
inoremap <C-d>  <Delete>
inoremap <C-j>  <ESC>

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

" インデント関連
set smartindent
set autoindent
set shiftwidth=2
filetype plugin on
filetype indent on

" Go のプラグイン
set rtp+=$GOROOT/misc/vim

" ejs は html モード
autocmd BufNewFile,BufRead *.ejs set ft=html
" md は markdown モード
autocmd BufNewFile,BufRead *.md set ft=markdown
" go は go mode
autocmd BufNewFile,BufRead *.go set ft=go

" go のファイルは保存時に自動 fmt
autocmd BufWritePre *.go Fmt

" スケルトン
augroup template-file
  autocmd!
  "autocmd BufNewFile *.go 0r $HOME/.vim/template/main.go
  "autocmd BufNewFile *_test.go gg | 0r $HOME/.vim/template/test.go

  function! s:ReadGoTemplate(name)
    if a:name =~# '_test.go'
      0r $HOME/.vim/template/test.go
    else
      0r $HOME/.vim/template/main.go
    endif
  endfunction
  autocmd BufNewFile *.go call <SID>ReadGoTemplate(expand('%'))
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
colorscheme desert
