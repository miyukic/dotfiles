@echo off
chcp 65001

@rem scoopコマンド存在確認

WHERE /Q scoop
IF "%ERRORELEVEL%" == "1" (
    echo "scoopコマンドがありません"
    echo "starshipをインストールするにはscoopが必要です"
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

rem .configフォルダの作成
IF NOT EXIST %USERPROFILE%\.config\ (
    echo %USERPROFILE%\.config を作成します
    mkdir %USERPROFILE%\.config
)

rem starship設定ファイルの作成(シンボリックリンクの作成)
IF NOT EXIST %USERPROFILE%\.config\starship.toml (
    GOTO INSTALL_STARSHIP_CONFIG
) ELSE (
    GOTO FIN_STARSHIP_CONFIG
)
:INSTALL_STARSHIP_CONFIG
echo "starshipの設定ファイル[~\.config\starshop.toml]"
echo "を作成しますか?[実際には設定ファイルへのシンボリックリンクが生成されます] Y/N"
set /P UserResp="入力: "
rem echo %UserResp%
IF /i "%UserResp%" == "Y" (
    GOTO STARSHIP_INSTALL
) ELSE (
    GOTO FIN_STARSHIP_INSTALL
)
:STARSHIP_INSTALL
WHERE /Q scoop
IF "%ERRORELEVEL%" == "1" (
    echo "PowerShellをインストールします"
    winget install --id Microsoft.PowerShell --source winget
)
pwsh -ExecutionPolicy RemoteSigned .\starship_install.ps1
echo インストールが終わりました。
:FIN_STARSHIP_CONFIG

