rem https://raw.githubusercontent.com/miyukic/dotfiles/master/bootstrap.bat
@echo off
chcp 65001

if "%1" == "curl" (
    GOTO GIT_INSTALL
) else (
    GOTO START
)

:GIT_INSTALL
WHERE /Q git
IF "%ERRORELEVEL%" == "0" (
    GOTO DOTFILES_CLONE
) ELSE (
    winget install Git.Git
)
:DOTFILES_CLONE
git clone https://github.com/miyukic/dotfiles.git %USERPROFILE%\dotfiles
%USERPROFILE%\dotfiles\bootstrap.bat auto
exit

:START
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

if NOT "%1" == "auto" (
    echo ✅ すべてのセットアップが完了しました。
    @pause
) ELSE (
    echo;
    echo;
    echo ✅ すべてのセットアップが完了しました。
)
