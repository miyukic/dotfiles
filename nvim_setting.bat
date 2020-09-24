@echo off

rem このbatfileはneovimに必要なコマンドとアプリケーションを自動インストールします。

rem scoopのインストール
where /Q scoop
if %ERRORLEVEL% == 1 (
    echo ==================================================
    echo scoopのインストールを開始します....
    pwsh -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    rem scoopのインストール
    pwsh -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。
)

rem gitコマンドのインストール
where /Q git
if %ERRORLEVEL% == 1 (
    echo ==================================================
    echo 手動でgitへパスを通しますか？(Y/N)
    set /P USR_RESP="入力:"
    echo.
    if /i %USR_RESP% == "N" (
        echo scoopでgitをインストールしますか？(Y/N)
        set /P USR_RESP="入力:"
        if /i %USR_RESP% == "N" (
            pwsh -c scoop update
            pwsh -c scoop install git
        ) else (
        echo WSLのgit等を手動でパスを通してください。
        )
        echo.
    )
)
echo ==================================================

rem Rubyの設定
echo Rubyのインストールを開始します。
pwsh -c scoop install ruby && gem install neovim
for /F %%i in ('which neovim-ruby-host') do set INSTALL_PATH=%%i
echo ==================================================
echo %INSTALL_PATH%にあります。

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
@pause
