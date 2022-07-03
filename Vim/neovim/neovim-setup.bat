@echo off
chcp 932

rem このbatfileはneovimに必要なコマンドとアプリケーションを自動インストールします。

rem scoopのインストール
where /Q scoop
if "%ERRORLEVEL%" == "1" (
    GOTO SCOOP
) ELSE (
    GOTO SCOOP_FIN
)
:SCOOP
echo ==================================================
echo scoopのインストールを開始します....
powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
rem scoopのインストール
powershell -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。
:SCOOP_FIN

rem gitコマンドのインストール
where /Q git
if "%ERRORLEVEL%" == "1" (
    GOTO GIT
) else (
    GOTO FIN_GIT
)
:GIT
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
:FIN_GIT
echo ==================================================

rem Rubyの設定
echo Rubyのインストールを開始します。
powershell -c "scoop install ruby && gem install neovim"
for /F %%i in ('which neovim-ruby-host') do set INSTALL_PATH=%%i
echo ==================================================
echo %INSTALL_PATH% にあります。

rem npmのインストール
echo ─────────────────────────────────────────────────────────────────────────
echo nvmをインストールします。
echo ─────────────────────────────────────────────────────────────────────────
powershell -c scoop install nvm
echo nvm list available で最新のLTS版バージョンを確認する。
echo nvm install <version> でインストール ex) nvm install 12.18.4
echo 最後に利用したいバージョンを指定する（ここで環境変数にパスが追加される）
echo ex) nvm use 12.18.4
echo ─────────────────────────────────────────────────────────────────────────

rem Pythonの設定
echo ==================================================
rem Todo スクリプト未作成


rem ここから、vimrcの設置とvimplugのインストールを行います。

set TARGET=%USERPROFILE%\AppData\Local\nvim\
set VIMRC_NAME=init.vim
set GVIMRC_NAME=ginit.vim

SET CD=%~dp0
SET VIM=%CD:~0,-7%
set REAL_VIMRC=vimrc
set REAL_GVIMRC=gvimrc

echo "現在のディレクトリ==> %~dp0"
echo %TARGET%にシンボリックリンクを作成します。
rem .vimrc
if not exist %TARGET%%VIMRC_NAME% (
    GOTO NOT_EXIST_VIMRC
) else (
    GOTO EXIST_VIMRC
)

:NOT_EXIST_VIMRC
if not exist %TARGET% (
    GOTO MKDIR_VIMRC
)
:MKDIR_VIMRC
echo %TARGET%を作成します。
mkdir %TARGET%
echo %TARGET%を作成しました。
if exist %VIM%%REAL_VIMRC% (
    mklink %TARGET%%VIMRC_NAME% %VIM%%REAL_VIMRC% 
    echo %TARGET%%VIMRC_NAME% ==> %VIM%%REAL_VIMRC%
) else (
    echo %VIM%%REAL_VIMRC% が見つかりませんでした。
)
GOTO FIN_VIMRC

:EXIST_VIMRC
echo;
echo すでに %VIMRC_NAME% が存在するので、
echo 新たにシンボリックリンクを作成する必要はありません。
echo "張り直しますか？<Y/N>"
set /P UserResp="入力: "
IF /i "%UserResp%" == "Y" (
    GOTO YES_VIMRC
) ELSE (
    GOTO NO_VIMRC
)
GOTO FIN_VIMRC

:YES_VIMRC
rem echo mklink を実行します。
del %TARGET%%VIMRC_NAME%
mklink %TARGET%%VIMRC_NAME% %VIM%%REAL_VIMRC%
echo %TARGET%%VIMRC_NAME% ==> %VIM%%REAL_VIMRC%
GOTO FIN_VIMRC
:NO_VIMRC
echo 張りませんでした。
:FIN_VIMRC
echo ==============================================================
rem .gvimrc
if not exist %TARGET%%GVIMRC_NAME% (
    GOTO NOT_EXIST_GVIMRC
) else (
    GOTO EXIST_GVIMRC
)
:NOT_EXIST_GVIMRC
if not exist %TARGET% (
    echo %TARGET%を作成します。
    mkdir %TARGET%
    echo %TARGET%を作成しました。
)
if exist %VIM%%REAL_VIMRC% (
    echo mklink を実行し、%GVIMRC_NAME%を作成します。
    mklink %TARGET%%GVIMRC_NAME% %VIM%%REAL_VIMRC%
    echo %TARGET%%GVIMRC_NAME% ==> %VIM%%REAL_VIMRC%
) else (
    echo ".gvimrc" が見つかりませんでした。
)
GOTO FIN_GVIMRC
:EXIST_GVIMRC

echo すでに %GVIMRC_NAME% が存在するので、
echo 新たにシンボリックリンクを作成する必要はありません。
set /P UserResp="張り直しますか<Y/N>？"
IF /i "%UserResp%" == "Y" (
    GOTO YES_GVIMRC
) ELSE (
    GOTO NO_GVIMRC
)
:YES_GVIMRC
echo mklink を実行します。
del %TARGET%%GVIMRC_NAME%
mklink %TARGET%%GVIMRC_NAME% %VIM%%REAL_GVIMRC%
echo %TARGET%%GVIMRC_NAME% ==> %VIM%%REAL_GVIMRC%
GOTO FIN_GVIMRC
:NO_GVIMRC
echo 張りませんでした。
:FIN_GVIMRC

rem vim-plugのインストール
set VIMPLUG=%USERPROFILE%\appdata\local\nvim\autoload\plug.vim
if not exist %VIMPLUG% (
    echo vim-plugのインストールを行います。
    curl -fLo %VIMPLUG% --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo インストールが完了しました。
)

rem PowerShellを使ったvimplug導入(動かない)
rem  vim-plugのインストール
rem where /Q pwsh
rem set VIMPLUG=~\appdata\local\nvim\autoload\plug.vim
rem if not exist %VIMPLUG% (
rem echo vim-plugのインストールを行います。
rem     if "%ERRORLEVEL%" == "0" (
rem         pwsh -c md ~\appdata\local\nvim\autoload
rem         pwsh -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         pwsh -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     ) else (
rem         powershell -c md ~\appdata\local\nvim\autoload
rem         powershell -c $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
rem         powershell -c (new-object net.webclient).downloadfile($uri, $executioncontext.sessionstate.path.getunresolvedproviderpathfrompspath("~\appdata\local\nvim\autoload\plug.vim"))
rem     )
rem )

echo すべての処理が終わりました。
chcp 65001
@pause
