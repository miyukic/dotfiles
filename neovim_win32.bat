@echo off

rem このバッチファイルはvimrcの設置とvimplugのインストールを行います。

set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
set gvimrc_name=ginit.vim

echo "現在のディレクトリ==> %~dp0"
echo %target%にシンボリックリンクを作成します。
rem vimrc
if not exist %target%%vimrc_name% (
    if not exist %target% (
        echo %target%を作成します。
        mkdir %target%
        echo %target%を作成しました。
    )
    if exist %~dp0.vimrc (
        echo mklink を実行します。
        mklink %target%%vimrc_name% %~dp0\.vimrc
        echo %target%%vimrc_name% ==> %~dp0\.vimrc
    ) else (
        echo ".vimrc" が見つかりませんでした。
    )
) else (
    echo すでに %vimrc_name% が存在するので、
    echo 新たにシンボリックリンクを作成する必要はありません。
)
echo ==============================================================
rem gvimrc
if not exist %target%%gvimrc_name% (
    if not exist %target% (
        echo %target%を作成します。
        mkdir %target%
        echo %target%を作成しました。
    )
    if exist %~dp0.gvimrc (
        echo mklink を実行し、%gvimrc_name%を作成します。
        mklink %target%%gvimrc_name% %~dp0\.gvimrc
        echo %target%%gvimrc_name% ==> %~dp0\.gvimrc
    ) else (
        echo ".gvimrc" が見つかりませんでした。
    )
) else (
    echo すでに %gvimrc_name% が存在するので、
    echo 新たにシンボリックリンクを作成する必要はありません。
)

rem vim-plugのインストール
where /Q pwsh
set VIMPLUG=~\appdata\local\nvim\autoload\plug.vim
if not exist %VIMPLUG% (
echo vim-plugのインストールを行います。
    if %ERRORLEVEL% == 0 (
        pwsh -c md ~\appdata\local\nvim\autoload
        pwsh -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        pwsh -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
    ) else (
        powershell -c md ~\appdata\local\nvim\autoload
        powershell -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        powershell -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
    )
)

echo すべての処理が終わりました。
@pause

>>>>>>> eea6481465e4ece026c519b4494d5b1c9fa5e364
