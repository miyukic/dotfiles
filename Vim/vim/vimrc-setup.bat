@echo off
chcp 65001

rem echo %~dp0

SET CD=%~dp0
rem 実行ディレクトリの末尾から "\vim\" (5文字) を削って、1つ上の階層を取得
SET VIM=%CD:~0,-5%

if exist %USERPROFILE%\.gvimrc del %USERPROFILE%\.gvimrc
mklink %USERPROFILE%\.gvimrc %VIM%\gvimrc
if exist %USERPROFILE%\.vimrc del %USERPROFILE%\.vimrc
mklink %USERPROFILE%\.vimrc %VIM%\vimrc
rem vim-plugのインストール
set VIMPLUG=%USERPROFILE%/vimfiles/autoload/plug.vim
if not exist %VIMPLUG% (
echo vim-plugのインストールを行います。
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
)
