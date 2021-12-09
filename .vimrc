set encoding=utf-8
if has('kaoriya')
    let g:no_vimrc_example=0
    let g:vimrc_local_finish=1
    let g:gvimrc_local_finish=1
 
    "$VIM/plugins/kaoriya/autodate.vim
    let plugin_autodate_disable  = 1
    "$VIM/plugins/kaoriya/cmdex.vim
    let plugin_cmdex_disable     = 1
    "$VIM/plugins/kaoriya/dicwin.vim
    let plugin_dicwin_disable    = 1
    "$VIMRUNTIME/plugin/format.vim
    let plugin_format_disable    = 1
    "$VIM/plugins/kaoriya/hz_ja.vim
    let plugin_hz_ja_disable     = 1
    "$VIM/plugins/kaoriya/scrnmode.vim
    let plugin_scrnmode_disable  = 1
    "$VIM/plugins/kaoriya/verifyenc.vim
    let plugin_verifyenc_disable = 1
endif
if !has('nvim')
    source $VIMRUNTIME/defaults.vim
endif
" vimplugin ================================================================

if filereadable(expand('~/.vim/autoload/plug.vim'))
            \|| filereadable(expand('~/AppData/Local/nvim/autoload/plug.vim'))
            \|| filereadable(expand('~/vimfiles/autoload/plug.vim'))
    if has('nvim') && has('win32') " Neovim on Windows
        let g:local = '~/AppData/Local/nvim/plugged'
    elseif has('unix') "vim on Linux
        let g:local = '~/.vim/plugged'
    else "gVim on Windows
        let g:local = '~/vimfiles/plugged'
    endif
    call plug#begin(local)
    if has('nvim')
    " Neovimのみのプラグイン
    else
    " ノーマルvimのみのプラグイン
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    "Plug 'hougo/neocomplcache.vim'
    Plug 'vim-jp/vimdoc-ja'
    Plug 'tpope/vim-sensible'
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'mattn/vim-lsp-icons'
    Plug 'tpope/vim-surround'

    " マルチカーソル
    Plug 'mg979/vim-visual-multi'

    "vimとGitの連携
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    " Linter系
    "Plug 'neomake/neomake'
    "Plug 'scrooloose/syntastic'
    
    " ColorScheme
    Plug 'nanotech/jellybeans.vim'
    Plug 'tomasr/molokai'
    Plug 'ayu-theme/ayu-vim'
    Plug 'NLKNguyen/papercolor-theme'
    " status bar
    Plug 'itchyny/lightline.vim'
    call plug#end()

    "vim-visual-multi
    nnoremap <silent> <M-j> <C-n>

    "status line plugin
    set noshowmode "ノーマルのモード表示をオフにする
    let g:lightline = {
                \ 'colorscheme': 'ayu_dark',
                \ 'mode_map': {'c': 'NORMAL'},
                \ 'active': {
                \   'left': [   [ 'mode', 'paste' ],
                \               [ 'gitbranch', 'readonly', 'filename', 'modidied'],
                \           ],
                \   'right' : [ [ 'lineinfo', 'syntastic' ], 
                \               [ 'percent' ],
                \               [ 'charcode', 'fileformat', 'fileencoding', 'filetype' ],
                \             ]
                \ },
                \ 'component_function': {
                \   'gitbranch':    'FugitiveHead',
                \ }
                \ }

    "syntasticの設定
    function! SyntasticSettings() abort
        let g:syntastic_check_on_open = 1
        "let g:syntastic_python_checkers = ['flake8', 'pep257', 'mypy']
        let g:syntastic_python_checkers = ['flake8', 'pep257', 'mypy']
        let g:syntastic_python_flake8_args = '--max-line-length=120'
    endfunction
    autocmd!
    autocmd User lsp_setup call SyntasticSettings()

    ""neomakeの設定
    "let g:neomake_python_enabled_makers = ['python', 'flake8', 'mypy']

    "autocmd FileType python setlocal omnifunc=jedi#completions
    "if !exists('g:neocomplete#force_omni_input_patterns')
    "    let g:neocomplete#force_omni_input_patterns = {}
    "endif
    "let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

    " lspの設定
    let g:asyncomplete_popup_delay = 200
    let g:lsp_text_edit_enabled = 1
    let g:lsp_diagnostics_enabled = 1 "リアルタイムのエラー表示を有効にする
    let g:lsp_diagnostics_echo_cursor = 1 "エラー行にカーソルをおあわせたときにエラーの理由をする
    let g:lsp_signs_enabled = 1 "エラーの表示をファイルに直接する
    let g:lsp_log_verbose = 1
    let g:lsp_log_file = expand('~/vim-lsp.log')
    " asyncomplete.vim log
    "let g:asyncomplete_log_file = expand('~/asyncomplete.log')

    " pylsの設定。LinterのON/OFFなどが可能
    let s:pyls_config = {'pyls': {'plugins': {
                \   'pycodestyle': {'enabled': v:false},
                \   'pydocstyle': {'enabled': v:false},
                \   'pylint': {'enabled': v:false},
                \   'flake8': {'enabled': v:false},
                \   'jedi_definition': {
                \     'follow_imports': v:true,
                \     'follow_builtin_imports': v:true,
                \   },
                \ }}}
    " pylsの起動定義
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': { server_info -> ['pyls'] },
                    \ 'whitelist': ['python'],
                    \ 'workspace_config': s:pyls_config
                    \})
    augroup END

    " omnisharpの設定 + Lspのキーバインド
    function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> <f2> <plug>(lsp-rename)
        nnoremap <silent> cre :LspRename<CR> "リファクタリング・リネーム
        nnoremap <silent> <C-]> :LspDefinition<CR> "定義ジャンプ
        nnoremap <silent> <C-Space> :LspCodeAction<CR>
        nnoremap <silent> gh :<C-u>LspHover<CR> "ghに割り当てると選択モードが使えなくなる
        nnoremap <Leader>n :<C-u>LspReferences<CR>
        nnoremap <Leader>f :<C-u>LspDocumentDiagnostics<CR>
        nnoremap <Leader>s :<C-u>LspDocumentFormat<CR>
    endfunction
    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END


endif
" vimplugin setting END ====================================================

" コマンドライン補完
set wildmenu
set wildmode=list:full

" vim の矩形選択で文字が無くても右へ進める
set virtualedit=block

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

" menuone補完が一個しかなくても常に補完を出すのと補完候補を挿入しない。
set completeopt=menuone,noinsert

"Terminal設定
if has('nvim')
    " <C-w>でvimと同じ動きにする
    tnoremap <C-w> <C-\><C-n><C-w> " 
     " ターミナルに切り替えたとき自動的にインサートモードにする
    "autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
elseif !has('nvim')
    " ターミナルに移ったときにインサートモードを抜けてノーマルモードにする
    " \<C-\>\<C-n>のように\でスケープすると、キー入力として呼び出せる
    autocmd WinEnter * if &buftype ==# 'terminal' | call timer_start(0, { -> feedkeys("\<C-\>\<C-n>") }) | endif
endif
" 既にターミナルを開いているときの処理
function! TermOpen()
    if has('nvim')
        execute "sp|term"
        "startinsert
    else
        if empty(term_list())
            execute "terminal"
        else
            call win_gotoid(win_findbuf(term_list()[0])[0])
        endif
    endif
endfunction

noremap <silent> <Space>@ :call TermOpen()<CR>

" 水平分割時に下に追加されるようになる
set splitbelow

if version >= 801
    " ターミナルの高さx幅
    set termwinsize=9x0
endif

" シェルのパス
"if has('win32') && has('nvim')
"   " set shell=pwsh.exe
"   " set shellcmdflag=-NoProfile\ -NoLogo\ -NonInteractive\ -Command
"endif

" バッファを閉じるときに保存しなくても良い
set hidden

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

" python3とRuby
if has('win32') && ('nvim')
    let g:python3_host_prog = '~\Anaconda3\python.EXE'
    let g:python_host_prog = '~\Anaconda3\envs\py27\python.EXE'
    let g:ruby_host_prog = '~\scoop\apps\ruby\current\gems\bin\neovim-ruby-host.bat'
elseif has('unix') && ('nvim')
endif

" 256色
set t_Co=256~

" True Color(24bit Color) サポート
"set termguicolors
if has('nvim')
    set termguicolors
endif

" 補完ウィンドウ等の透明度0~100
if has('nvim') 
    set pumblend=10 
endif

" clipboardを有効にする
if has('nvim') || !has('win32')
set clipboard&
set clipboard^=unnamedplus
endif

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
nnoremap <silent> <C-h> :bprev<CR>
nnoremap <silent> <C-l> :bnext<CR>

" 選択範囲のインデントを連続して変更
vnoremap < <gv
vnoremap > >gv

" スクロール時に表示を指定行確保
set scrolloff=40

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
set number

" ファイルを上書きする前にバックアップを作ることを無効化
set nowritebackup

" 検索するときに大文字小文字を区別しない
set ignorecase

" 検索時に大文字を含んでいたら大/小を区別
set smartcase

" 行末のスペースを可視化
set nolist
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

augroup ColorSchemeSetting
    "colorscheme jellybeans
    " ayu color
    "colorscheme ayu
    "ayucolor="light"  " for light version of theme
    "let ayucolor="mirage" " for mirage version of theme
    "let ayucolor="dark"   " for dark version of theme
    
    colorscheme PaperColor " カラースキーマ

    " カラースキーマ
    "colorscheme molokai
    " ダーク系のカラースキームを使う
    set background=dark

    if has('nvim')
        " 256Color のときのカレント行の色設定
        "autocmd ColorScheme * highlight CursorLine cterm=underline ctermfg=NONE "ctermbg=NONE
        " 24bitColorのときのカレント行の色設定
        "autocmd ColorScheme * highlight CursorLine gui=underline guifg=NONE guibg=NONE ctermbg=NONE
        highlight CursorLine gui=underline guifg=NONE guibg=NONE ctermbg=NONE
        " 背景色設定
        highlight Normal guibg=NONE
        highlight LineNr guibg=NONE
        highlight VertSplit guibg=NONE
        highlight Special guibg=NONE
        highlight Identifier guibg=NONE
        highlight NonText guibg=NONE
    else
        if &termguicolors
            " 24bitColorのときのカレント行の色設定
            autocmd ColorScheme * highlight CursorLine cterm=underline guifg=NONE guibg=NONE
            " 24bitColorのときの背景色設定
            highlight Normal guibg=Gray3
            highlight LineNr guibg=Gray3
            highlight VertSplit guibg=Gray3
            highlight Special guibg=Gray3
            highlight Identifier guibg=Gray3
            highlight NonText guibg=Gray3
        else
            " 256Color のときのカレント行の色設定
            "highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
            autocmd ColorScheme * highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
            " 256Color のときの背景色の設定
            highlight Normal guibg=NONE
            highlight LineNr guibg=NONE
            highlight VertSplit guibg=NONE
            highlight Special guibg=NONE
            highlight Identifier guibg=NONE
            "highlight Normal ctermbg=NONE
            "highlight LineNr ctermbg=NONE
            "highlight VertSplit ctermbg=NONE
            "highlight Special ctermbg=NONE
            "highlight Identifier ctermbg=NONE
            "highlight EndOfBuffer ctermbg=NONE
            "highlight Folded ctermbg=NONE
            "highlight Conceal ctermbg=NONE
            "highlight NonText ctermbg=NONE
        endif
    endif

    " Errorの色を変更
    highlight Error ctermfg=15 ctermbg=9 guifg=#F6F1DF guibg=#882929
    " Todoの色設定
    highlight Todo ctermfg=0 guifg=#F78A81

augroup END

" 現在の行を強調表示（縦）
"set cursorcolumn

" 行末の1文字先までカーソルを移動できるように
"set virtualedit=onemore

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" 折り返さない
set wrap

