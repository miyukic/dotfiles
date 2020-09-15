@echo off
rem scoopのインストール
where /Q scoop
if %ERRORLEVEL% == 1 (
    echo ==================================================
    echo scoopのインストールを開始します....
    pwsh -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    rem scoopのインストール
    pwsh -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。
)

rem gitコマンド
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
        )
        echo.
    )
)

rem Rubyの設定
pwsh -c scoop install ruby && gem install neovim
for /F %%i in ('which neovim-ruby-host') do set INSTALL_PATH=%%i
echo ==================================================
echo %INSTALL_PATH%にあります。

rem Pythonの設定
echo ==================================================
rem Todo スクリプト未作成
@pause
