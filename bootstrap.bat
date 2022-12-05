rem https://raw.githubusercontent.com/miyukic/dotfiles/master/bootstrap.bat
@echo off
chcp 65001

WHERE /Q git
IF "%ERRORELEVEL%" == "0" (
    GOTO DOTFILES_CLONE
) ELSE (
    GOTO GIT_INSTALL
)

:GIT_INSTALL
rem winget install Git.Git
WHERE /Q scoop
IF "%ERRORELEVEL%" == "0" (
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
git clone https://github.com/miyukic/dotfiles.git %USERPROFILE%\dotfiles
start %USERPROFILE%\dotfiles\bootstrap.bat auto
exit

:START
echo 現在のディレクトリ
echo %~dp0
echo;
rem starship
if NOT "%1" == "auto" (
    .\starship\starship_install.bat
) ELSE (
    echo Y | .\starship\starship_install.bat
)
echo ✅ starhipのインストールが終わりました。

rem git config
if NOT "%1" == "auto" (
    .\Git\gitinit.bat
) ELSE (
    echo Y | .\Git\gitinit.bat
)
echo ✅ gitconfigの設定が終わりました。

rem pwshのインストール
%~dp0\PowerShell\vimrc-setup.bat
pwsh -ExecutionPolicy RemoteSigned -Command .\PowerShell\setup.ps1
echo "✅ PowerShell(pwsh)のインストールが終わりました。"


rem Vimのインストール
scoop install vim-nightly
%~dp0\Vim\vim\vimrc-setup.bat
echo ✅ bimのインストールが終わりました。

if NOT "%1" == "auto" (
    echo ✅ すべてのセットアップが完了しました。
    @pause
) ELSE (
    echo;
    echo;
    echo ✅ すべてのセットアップが完了しました。
)
