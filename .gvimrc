
" マウスを有効にする
set mouse=a

"行番号
set number

" カレント行の色設定
autocmd ColorScheme * hi CursorLine gui=NONE guifg=NONE guibg=grey6

" カラースキーマ
colorscheme jellybeans

" status line
let g:lightline = {
\ 'colorscheme': 'molokai',
\ }

" 背景色設定
"hi Normal guibg=NONE
"hi LineNr guibg=NONE
"hi VertSplit guibg=NONE
"hi Special guibg=NONE "＆等の記号
"hi Identifier guibg=NONE "予約語? 

" フォント設定
GuiFont! Cica:h12

" 起動時にフルスクリーン(1)
"call GuiWindowFullscreen(1)

" 右クリックメニュー 
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <RightMouse> :call GuiShowContextMenu()<CR>gv

" 余分な空バッファを表示しないようにする
if has('nvim') && @% == ""
  bd
endif

" 個別設定
if has('win32')
    if filereadable(expand('~/AppData/local/nvim/indifile.vim'))
        source ~/AppData/local/nvim/indifile.vim
    endif
endif
