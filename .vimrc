"if &compatible
"  set nocompatible
"endif
"" Add the dein installation directory into runtimepath
"set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
"
"if dein#load_state('~/.cache/dein')
"  call dein#begin('~/.cache/dein')
"
"  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
"  call dein#add('Shougo/deoplete.nvim')
"  if !has('nvim')
"    call dein#add('roxma/nvim-yarp')
"    call dein#add('roxma/vim-hug-neovim-rpc')
"  endif
"
"  call dein#end()
"  call dein#save_state()
"endif
"
"filetype plugin indent on
"syntax enable

" vimplugin
call plug#begin()
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/deoplete.nvim' "コード補完
Plug 'tpope/vim-sensible'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'Shougo/deoplete.nvim'
Plug 'lighttiger2505/deoplete-vim-lsp'
Plug 'tpope/vim-surround'
" ColorScheme
Plug 'nanotech/jellybeans.vim'
Plug 'tomasr/molokai'
call plug#end()

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

" 既にターミナルを開いているときの処理
"function! TermOpen()
"    if empty(term_list())
"        execute "terminal"
"    else
"        call win_gotoid(win_findbuf(term_list()[0])[0])
"    endif
"endfunction

"command Term :call TermOpen()<CR>

" バッファを閉じるときに保存しなくても良い
set hidden

" 水平分割時に下に追加されるようになる
set splitbelow

" ターミナルの高さx幅
"set termwinsize=7x0

"コード自動判定
"fileformats=unix,dos,mac

" タブの幅設定
"set noexpandtab
set expandtab
set tabstop=4
set shiftwidth=4

" Python設定
autocmd FileType python setlocal tabstop=4

" 256色
set t_Co=256~

" True Color(24bit Color) サポート
"set termguicolors

" clipboardを有効にする
set clipboard&
set clipboard^=unnamedplus

" マウスを有効にする
"set mouse=a

" マウススクロールを有効にする
"set ttymouse=xterm2

" ノーマルモード中にEnterで下に行を追加
"noremap <CR> o<Esc>

"x キー削除でデフォルトレジスタに入れない
nnoremap x "_x
vnoremap x "_x

"折り返した行内を移動
noremap j gj
noremap k gk

"インサートモードで bash 風キーマップ
"inoremap <C-a> <C-o>^
"inoremap <C-e> <C-o>$<Right>
"inoremap <C-b> <Left>
"inoremap <C-f> <Right>
"inoremap <C-n> <Down>
"inoremap <C-p> <Up>
"inoremap <C-h> <BS>
"inoremap <C-d> <Del>
"inoremap <C-k> <C-o>D<Right>
"inoremap <C-u> <C-o>d^
"inoremap <C-w> <C-o>db

"バッファの切り替えを<C-j> <C-k>で行う
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

" 選択範囲のインデントを連続して変更
vnoremap < <gv
vnoremap > >gv

" スクロール時に表示を指定行確保
set scrolloff=8

" ファイル名表示
set statusline=%F 

" 行、列番号
"set statusline=%f%m%=%3l,%3c

" ステータスラインカスタマイズ
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" 変更のチェック表示
set statusline+=%m

" ステータスラインの表示 0:表示しない 1:2つ以上ウィンドウがあるときのみ 2:常に表示
set laststatus=1

" 内容が変更されたら自動リロード
set autoread

" 行番号表示
"set number

" ファイルを上書きする前にバックアップを作ることを無効化
set nowritebackup

" 検索するときに大文字小文字を区別しない
set ignorecase

" 検索時に大文字を含んでいたら大/小を区別
set smartcase

" 行末のスペースを可視化
set list
set listchars=tab:^\ ,trail:~,eol:↲

" 不可視文字（tab:tab,trail:行末スペース,nbsp:ノーブレークスペース,eol:改行）
"set list
"set listchars=tab:»-,trail:-,nbsp:%,eol:↲

" 対応する括弧を強調表示
set showmatch

" タイトルを表示
set title

" シンタックスハイライト
syntax on

" 現在の行を強調表示
set cursorline

" 256Color のときのカレント行の色設定
autocmd ColorScheme * hi CursorLine term=NONE ctermfg=NONE "ctermbg=NONE
"
"24bitColorのときのカレント行の色設定
autocmd ColorScheme * hi CursorLine term=NONE guifg=NONE guibg=NONE

" カラースキーマ
colorscheme molokai

"文字コードをUFT-8に設定
set fenc=utf-8


" コマンドラインの補完
set wildmode=list:longest

" 現在の行を強調表示（縦）
"set cursorcolumn

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

" ダーク系のカラースキームを使う
set background=dark

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" 折り返さない
set nowrap

