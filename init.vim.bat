@rem Windowsでnvim向けの初期設定をするbatスクリプト

@echo off
set target=%USERPROFILE%\AppData\Local\nvim\
set vimrc_name=init.vim
set gvimrc_name=ginit.vim

echo "現在のディレクトリ==> %~dp0"
echo %target%にシンボリックリンクを作成します。
@rem vimrcの設置
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
rem gvimrcの設置
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

@rem vim-plugのインストール
rem where /Q pwsh
rem set VIMPLUG=%USERPROFILE%\appdata\local\nvim\autoload\plug.vim
rem set url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
rem if not exist %VIMPLUG% (
rem echo vim-plugのインストールを行います。
rem     if %ERRORLEVEL% == 0 (
rem         pwsh -c md ~\appdata\local\nvim\autoload
rem         rem pwsh -c $url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         pwsh -c (new-object net.webclient).downloadfile(%url%, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     ) else (
rem         powershell -c md ~\appdata\local\nvim\autoload
rem         rem powershell -c $url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         powershell -c (new-object net.webclient).downloadfile(%url%, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     )
rem )

@rem nvim向けpythonのインストール
set PATH=%PATH%;%USERPROFILE%\Anaconda3\Library\bin;%USERPROFILE%\Anaconda3\Scripts;%USERPROFILE%\Anaconda3\condabin
where /Q python
if %ERRORLEVEL% == 0 (
    pip install pynvim
)


echo すべての処理が終わりました。
@pause

