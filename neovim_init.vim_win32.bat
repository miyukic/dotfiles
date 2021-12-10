@echo off
chcp 65001

rem このbatfileはneovimに必要なコマンドとアプリケーションを自動インストールします。

rem scoopのインストール
where /Q scoop
if %ERRORLEVEL% == 1 (
    echo ==================================================
    echo scoopのインストールを開始します....
    powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    rem scoopのインストール
    powershell -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。
)

rem gitコマンドのインストール
where /Q git
if %ERRORLEVEL% == 1 (
    echo ==================================================
    echo 自動でgitへパスを通しますか？<Y/N>
    set /P UserResp="入力: "
    echo.
    if /i %UserResp% == "Y" (
        echo gitコマンドが必要です。
        echo WSLのgitを流用する[W], scoopでgitをインストールする[G], スキップする[C]
        :SELECT
        set /P UserResp="入力: "
        if /i %UserResp% == "S" (
            powershell -c scoop update
            powershell -c scoop install git
        ) else if /i %SerResp% == "W" (
            curl -fLo %SystemRoot%\system32\git.exe https://www.dropbox.com/s/c2qpu3tk5gwy2r1/wslgit.exe?dl=0
        ) else if %SerResp% == "C" (
        ) else (
            echo 何れかのキー[W, G, C]を選択してください。
            goto SELECT
        )
        echo.
    )
)
echo ==================================================

rem Rubyの設定
echo Rubyのインストールを開始します。
powershell -c scoop install ruby && gem install neovim
for /F %%i in ('which neovim-ruby-host') do set INSTALL_PATH=%%i
echo ==================================================
echo %INSTALL_PATH% にあります。

rem npmのインストール
echo =========================================================================
echo nvmをインストールします。
echo =========================================================================
powershell -c scoop install nvm
echo nvm list available で最新のLTS版バージョンを確認する。
echo nvm install <version> でインストール ex) nvm install 12.18.4
echo 最後に利用したいバージョンを指定する（ここで環境変数にパスが追加される）
echo ex) nvm use 12.18.4
echo =========================================================================

rem Pythonの設定
echo ==================================================
rem Todo スクリプト未作成


rem ここから、vimrcの設置とvimplugのインストールを行います。

set TARGET=%USERPROFILE%\AppData\Local\nvim\
set VIMRC_NAME=init.vim
set GVIMRC_NAME=ginit.vim

echo "現在のディレクトリ==> %~dp0"
echo %TARGET%にシンボリックリンクを作成します。
rem .vimrc
if not exist %TARGET%%VIMRC_NAME% (
    if not exist %TARGET% (
        echo %TARGET%を作成します。
        mkdir %TARGET%
        echo %TARGET%を作成しました。
    )
    if exist %~dp0.vimrc (
        echo mklink を実行します。
        mklink %TARGET%%VIMRC_NAME% %~dp0\.vimrc
        echo %TARGET%%VIMRC_NAME% ==> %~dp0\.vimrc
    ) else (
        echo ".vimrc" が見つかりませんでした。
    )
) else (
    echo すでに %VIMRC_NAME% が存在するので、
    echo 新たにシンボリックリンクを作成する必要はありません。
)
echo ==============================================================
rem .gvimrc
if not exist %TARGET%%GVIMRC_NAME% (
    if not exist %TARGET% (
        echo %TARGET%を作成します。
        mkdir %TARGET%
        echo %TARGET%を作成しました。
    )
    if exist %~dp0.gvimrc (
        echo mklink を実行し、%GVIMRC_NAME%を作成します。
        mklink %TARGET%%GVIMRC_NAME% %~dp0\.gvimrc
        echo %TARGET%%GVIMRC_NAME% ==> %~dp0\.gvimrc
    ) else (
        echo ".gvimrc" が見つかりませんでした。
    )
) else (
    echo すでに %GVIMRC_NAME% が存在するので、
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
