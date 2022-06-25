@echo off
mklink %USERPROFILE%\.gvimrc %USERPROFILE%\dotfiles\.gvimrc
mklink %USERPROFILE%\.vimrc %USERPROFILE%\dotfiles\.vimrc
rem vim-plugのインストール
set VIMPLUG=%USERPROFILE%/vimfiles/autoload/plug.vim
if not exist %VIMPLUG% (
echo vim-plugのインストールを行います。
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
)
@pause
