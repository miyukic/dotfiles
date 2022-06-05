rem @echo off
chcp 65001
rem scoopコマンド存在確認

WHERE /Q scoop
IF %ERRORELEVEL% == 0 (
    scoop install starship
) ELSE (
    echo "scoopコマンドがありません"
    exit
)

IF NOT EXIST %USERPROFILE%\.config (
    mkdir %USERPROFILE%\.config

    setlocal
    for /f "usebackq delims=" %%A in (`ver`) do set PATH=%%A
    echo %PATH%

    rem mklink %USERPROFILE%\.config\starship.toml %~dp0
) ELSE (
    echo ".configフォルダが既に存在しているため作成できませんでした"
)
