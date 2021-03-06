set backup
set backspace=1
" no errorbells
set history=20
" set jignorecase
set backupdir=>/home/ogasawara/tmp/jvim
set directory=>/home/ogasawara/tmp/jvim
set ruler
set shiftwidth=4
" set smartindent
set autoindent
" set cindent
set backspace=2
set whichwrap=24
set showmatch
set splitright
set splitbelow
set tw=0

" neocomplcache
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化

" ============================================
"  config
" ============================================
set number
syntax on
highlight Comment ctermfg=DarkRed
" set enc=euc-jp
" set enc=utf-8
" set enc=sjis

" ============================================
" search map
" ============================================
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" ============================================
" 文字コードの自動認識
" ============================================
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" set encoding=utf-8
" set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp,sjis,ucs-2le,ucs2

" ============================================
" Tabの設定
" ============================================
" set expandtab
set ts=4 sw=4 sts=0

" ============================================
" 空行を挿入する
" ============================================
" http://vim-users.jp/2009/08/hack57/
nnoremap 0 :<C-u>call append(expand('.'), '')<Cr>j

" ============================================
" html
" ============================================
au BufNewFile,BufRead *.html :set ft=html
au BufNewFile,BufRead *.ctp  :set ft=html

" ============================================
" VimDiff
" ============================================
hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7
