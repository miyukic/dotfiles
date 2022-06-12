@echo off
chcp 65001

@rem scoopコマンド存在確認

WHERE /Q scoop
IF "%ERRORELEVEL%" == "1" (
    echo "scoopコマンドがありません"
    echo "starshipをインストールするにはscoopが必要です"
    rem scoopのインストール
    echo ==================================================
    echo scoopのインストールを開始します....
    powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    rem scoopのインストール
    powershell -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。

) ELSE (
    echo "scoopは既にインストールされています"
)

@rem starshipコマンド存在確認
WHERE /Q starship
IF "%ERRORELEVEL%" == "1" (
    echo "starshipをインストールします"
    scoop install starship
) ELSE (
    echo "starshipは既にインストールされています"
)



IF NOT EXIST %USERPROFILE%\.config\ (
    rem mkdir %USERPROFILE%\.config

    rem setlocal
    rem for /f "usebackq delims=" %%A in (`ver`) do set PATH=%%A
    rem echo %PATH%

    rem mklink %USERPROFILE%\.config\starship.toml %~dp0
) ELSE (
    echo ".configフォルダが既に存在しているため作成できませんでした"
)

pwsh ./starship_install.ps1
