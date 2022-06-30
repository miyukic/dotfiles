@echo off
chcp 65001

rem echo %~dp0

SET CD=%~dp0
SET VIM=%CD:~0,-4%

del %USERPROFILE%\.gvimrc
mklink %USERPROFILE%\.gvimrc %VIM%gvimrc
del %USERPROFILE%\.vimrc
mklink %USERPROFILE%\.vimrc %VIM%vimrc
rem vim-plugのインストール
set VIMPLUG=%USERPROFILE%/vimfiles/autoload/plug.vim
if not exist %VIMPLUG% (
echo vim-plugのインストールを行います。
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
)
@pause
