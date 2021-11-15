" マウスを有効にする
set mouse=a

"行番号
set number

" カレント行の色設定
autocmd ColorScheme * hi CursorLine gui=NONE guifg=NONE guibg=grey6


colorscheme jellybeans

" status line
"let g:lightline = {
"\ 'colorscheme': 'molokai',
"\ }

" 背景色設定
hi Normal guibg=grey3  
hi LineNr guibg=grey3  
hi VertSplit guibg=grey3  
hi Special guibg=grey3 "＆等の記号
hi Identifier guibg=grey3 "予約語? 

set renderingoptions=type:directx

if has('nvim') && has('win32') " neovim-qt 固有の設定
    let $MYGVIMRC = "~/AppData/local/nvim/ginit.vim"
    " フォント設定
    GuiFont! Cica:h12

    "右クリックメニュー 
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    vnoremap <RightMouse> :call GuiShowContextMenu()<CR>gv

    " GUIのTab非表示
    GuiTabline 0

    " GUIの補完メニュー非表示
    GuiPopupmenu 0

    " 起動時にフルスクリーン(1)
    "call GuiWindowFullscreen(1)

    " 個別設定
    let $INDIFILE = "~/AppData/local/nvim/indifile.vim"
        if has('win32') 
        if filereadable(expand('~/AppData/local/nvim/indifile.vim'))
            source ~/AppData/local/nvim/indifile.vim
        endif
    endif

else " gVim 固有の設定
    function! Change_font_size()
        set guifont=Cica:h18
    endfunction

    let g:load_cast_position_file = expand('~/vimcastposition')
    function! Set_window_cast_position()
        if filereadable(g:load_cast_position_file)
            execute 'source' g:load_cast_position_file
        endif
    endfunction
    
    " OSとのクリップボードの共有設定
    set clipboard=unnamed

    " フォント設定
    set guifont=CaskaydiaCove_Nerd_Font_Mono:h10"
    "set renderoptions=type:directx

    " ツールバー非表示
    set guioptions-=T

    " メニューバー非表示
    "set guioptions-=m
    
    " GUIのTab非表示
    set guioptions -=e

    " shをウィンドウ内で開く
    set guioptions+=!

    " 右スクロールバーを非表示
    set guioptions -=r


    " ウィンドウの位置とサイズを記憶する
    let g:save_window_file = expand('~/.vimwinpos')
    augroup SaveWindow
        autocmd!
        autocmd VimLeavePre * call s:save_window()
        function! s:save_window()
            let options = [
                        \ 'set columns=' . &columns,
                        \ 'set lines=' . &lines,
                        \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
                        \ ]
            call writefile(options, g:save_window_file)
        endfunction
    augroup END
    if filereadable(g:save_window_file)
        execute 'source' g:save_window_file
    endif 

endif

command! Cast call Change_font_size()
command! SetWindowCast call Set_window_cast_position()
