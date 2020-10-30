
" マウスを有効にする
set mouse=a

"行番号
set number

" カレント行の色設定
autocmd ColorScheme * hi CursorLine gui=NONE guifg=NONE guibg=grey6

" カラースキーマ
colorscheme ayu

" status line
"let g:lightline = {
"\ 'colorscheme': 'molokai',
"\ }

" 背景色設定
hi Normal guibg=BLACK
hi LineNr guibg=BLACK
hi VertSplit guibg=BLACK
hi Special guibg=BLACK "＆等の記号
hi Identifier guibg=BLACK "予約語? 

" フォント設定
"GuiFont! Cica:h12
set guifont=Cica:h12

" 起動時にフルスクリーン(1)
"call GuiWindowFullscreen(1)

" 右クリックメニュー 
"nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
"inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
"vnoremap <RightMouse> :call GuiShowContextMenu()<CR>gv

" ツールバー非表示
set guioptions-=T
" メニューバー非表示
"set guioptions-=m


" 個別設定
"if has('win32')
"    if filereadable(expand('~/AppData/local/nvim/indifile.vim'))
"        source ~/AppData/local/nvim/indifile.vim
"    endif
"endif
