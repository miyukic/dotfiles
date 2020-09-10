" vimplugin
if has('nvim') && has('win32')
    let g:local = '~/AppData/Local/nvim/plugged'
else
    let g:local = '~/.vim/plugged'
endif
call plug#begin(local)
if has('nvim')
else
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim' "コード補完
Plug 'mg979/vim-visual-multi' " マルチカーソル
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
Plug 'ayu-theme/ayu-vim'
call plug#end()

" vim の矩形選択で文字が無くても右へ進める
set virtualedit=block

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

" menuone補完が一個しかなくても常に補完を出すのと補完候補を挿入しない。
set completeopt=menuone,noinsert

" 既にターミナルを開いているときの処理
function! TermOpen()
    if has('nvim')
        execute "sp|term"
        startinsert
    else
        if empty(term_list())
                execute "terminal"
        else
            call win_gotoid(win_findbuf(term_list()[0])[0])
        endif
    endif
endfunction

noremap <silent> <Space>@ :call TermOpen()<CR>

" シェルのパス
"set shell=C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe\ -ExecutionPolicy\ Bypass

"Terminal設定
if has('nvim')
    tnoremap <C-w> <C-\><C-n><C-w>
    " ターミナルに切り替えたとき自動的にインサートモードにする
    autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
endif

" バッファを閉じるときに保存しなくても良い
set hidden

" 水平分割時に下に追加されるようになる
set splitbelow

if version >= 801
    " ターミナルの高さx幅
    set termwinsize=7x0
endif

"コード自動判定
set fileformats=unix,dos,mac

"ファイルエンコーディング自動判定
set fileencodings=utf-8,cp932,sjis,iso-2022-jp,euc-jp

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
set termguicolors

" 補完ウィンドウ等の透明度0~100
if has('nvim') 
    set pumblend=10 
endif

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
set scrolloff=5

" ファイル名表示
"set statusline=%F 

" 行、列番号
"set statusline=%f%m%=%3l,%3c

" ステータスラインカスタマイズ
set statusline=
set statusline+=%F%m%r%h%w\ %<[ENC=%{&fenc!=''?&fenc:&enc}]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%04.3b]\ [HEX=\%02.2B]\ [LEN=%L]%=(%02l,%02v)\ %p%%\ 
"色の付け方"%#Visual#

"ルーラーの表示
set ruler

" 変更のチェック表示
"set statusline+=%m

" ステータスラインの表示 0:表示しない 1:2つ以上ウィンドウがあるときのみ 2:常に表示
set laststatus=2

" ステータスラインの縦幅
set cmdheight=1

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

" ayu color
"yucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu " カラースキーマ

" カラースキーマ
"colorscheme molokai

if has('nvim')
    " 256Color のときのカレント行の色設定
    "autocmd ColorScheme * hi CursorLine cterm=underline ctermfg=NONE "ctermbg=NONE
    " 24bitColorのときのカレント行の色設定
    autocmd ColorScheme * highlight CursorLine gui=underline guifg=NONE guibg=NONE
else
    " 256Color のときのカレント行の色設定
    "autocmd ColorScheme * hi CursorLine cterm=underline ctermfg=NONE "ctermbg=NONE
    " 24bitColorのときのカレント行の色設定
    autocmd ColorScheme * hi CursorLine cterm=underline guifg=NONE guibg=NONE
endif

" ダーク系のカラースキームを使う
set background=dark

" 背景色設定
if has('nvim') 
    hi Normal guibg=NONE
    hi LineNr guibg=NONE
    hi VertSplit guibg=NONE
    hi Special guibg=NONE
    hi Identifier guibg=NONE
else
    hi Normal guibg=BLACK
    hi LineNr guibg=BLACK
    hi VertSplit guibg=BLACK
    hi Special guibg=BLACK
    hi Identifier guibg=BLACK
endif

" コマンドラインの補完
set wildmode=list:longest

" 現在の行を強調表示（縦）
"set cursorcolumn

" 行末の1文字先までカーソルを移動できるように
"set virtualedit=onemore

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" 折り返さない
set nowrap

