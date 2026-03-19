rem https://raw.githubusercontent.com/miyukic/dotfiles/master/bootstrap.bat
@echo off
chcp 65001


if "%1" == "auto" (
    GOTO START
) else (
    GOTO GIT_CHECK
)

:GIT_CHECK
WHERE /Q git
IF "%ERRORLEVEL%" == "0" (
    GOTO DOTFILES_CLONE
) ELSE (
    GOTO GIT_INSTALL
)

:GIT_INSTALL
rem Install Git via scoop if not found
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
set PATH=%PATH%;%USERPROFILE%\scoop\shims
echo 現在のディレクトリ
echo %~dp0
echo.

rem --- Enable Developer Mode ---
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d 1 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ 開発者モードを有効化しました。
)

rem --- Enable inline sudo for Windows 11 24H2 or later ---
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Sudo" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Sudo" /v Enabled /t REG_DWORD /d 3 /f >nul 2>&1
    echo ✅ インラインsudoを有効化しました。
)

rem starship
if NOT "%1" == "auto" (
    call .\starship\starship_install.bat
) ELSE (
    call .\starship\starship_install.bat auto
)
echo ✅ starshipのインストールが終わりました。

rem git config
call .\Git\gitinit.bat
echo ✅ gitconfigの設定が終わりました。

rem pwshのインストール
powershell -ExecutionPolicy RemoteSigned -File .\PowerShell\setup.ps1
call %~dp0\PowerShell\profile_placement.bat
echo "✅ PowerShell(pwsh)のインストールが終わりました。"

rem OpenSSH Server setup
gsudo pwsh -ExecutionPolicy RemoteSigned -File %~dp0\PowerShell\OpenSSH-Setup.ps1
echo ✅ OpenSSH Serverのセットアップが終わりました。

if NOT "%1" == "auto" (
    echo ✅ すべてのセットアップが完了しました。
    @pause
) ELSE (
    echo.
    echo.
    echo ✅ すべてのセットアップが完了しました。
)
