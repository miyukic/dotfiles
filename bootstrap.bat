rem https://raw.githubusercontent.com/miyukic/dotfiles/master/bootstrap.bat
@echo off
chcp 65001

if "%1" == "auto" (
    GOTO START
) else (
    GOTO GIT_INSTALL
)

GIT_INSTALL:

WHERE /Q git
IF "%ERRORLEVEL%" == "0" (
    GOTO DOTFILES_CLONE
) ELSE (
    GOTO GIT_INSTALL
)

:GIT_INSTALL
rem winget install Git.Git
WHERE /Q scoop
IF "%ERRORLEVEL%" == "0" (
    echo "scoopは既にインストールされています"
    GOTO SKIP_SCOOP_INSTALL
) ELSE (
    GOTO SCOOP_INSTALL
)

:SCOOP_INSTALL
echo scoopのインストールを開始します....
powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
rem scoopのインストール
powershell -c "iwr -useb get.scoop.sh | iex" && echo scoopのインストールが完了しました。
:SKIP_SCOOP_INSTALL
scoop install git

:DOTFILES_CLONE
if exist %USERPROFILE%\dotfiles (
    echo dotfilesは既に存在します
    GOTO START
)
git clone https://github.com/miyukic/dotfiles.git %USERPROFILE%\dotfiles
start %USERPROFILE%\dotfiles\bootstrap.bat auto
exit

:START
echo 現在のディレクトリ
echo %~dp0
echo.
rem starship
if NOT "%1" == "auto" (
    .\starship\starship_install.bat
) ELSE (
    .\starship\starship_install.bat auto
)
echo ✅ starshipのインストールが終わりました。

rem git config
.\Git\gitinit.bat
echo ✅ gitconfigの設定が終わりました。

rem pwshのインストール
powershell -ExecutionPolicy RemoteSigned -Command .\PowerShell\setup.ps1
%~dp0\PowerShell\profile_placement.bat
echo "✅ PowerShell(pwsh)のインストールが終わりました。"


rem Vimのインストール
scoop install vim-nightly
%~dp0\Vim\vim\vimrc-setup.bat
echo ✅ Vimのインストールが終わりました。

if NOT "%1" == "auto" (
    echo ✅ すべてのセットアップが完了しました。
    @pause
) ELSE (
    echo.
    echo.
    echo ✅ すべてのセットアップが完了しました。
)
