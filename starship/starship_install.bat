@echo off
chcp 65001

@rem scoopコマンド存在確認

echo;
echo;

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

echo;

@rem starshipコマンド存在確認
WHERE /Q starship
IF "%ERRORELEVEL%" == "1" (
    echo "starshipをインストールします"
    scoop install starship
) ELSE (
    echo "starshipは既にインストールされています"
)

echo;

rem .configフォルダの作成
IF NOT EXIST %USERPROFILE%\.config\ (
    echo %USERPROFILE%\.config を作成します
    mkdir %USERPROFILE%\.config
)

echo;

rem starship設定ファイルの作成(シンボリックリンクの作成)
IF NOT EXIST %USERPROFILE%\.config\starship.toml (
    GOTO NOTEXIST
) ELSE (
    GOTO EXIST
)

echo;

:INSTALL
rem echo ":INSTALL"
WHERE /Q pwsh
IF "%ERRORELEVEL%" == "1" (
    echo "PowerShellをインストールします"
    winget install --id Microsoft.PowerShell --source winget
)
pwsh -ExecutionPolicy RemoteSigned -Command .\luna.ps1 -flag "true"
GOTO EOS

:NOTEXIST
echo "starshipの設定ファイル[~\.config\starshop.toml]"
echo "を作成しますか?[実際には設定ファイルへのシンボリックリンクが生成されます] Y/N"
set /P UserResp="入力: "
rem echo %UserResp%
IF /i "%UserResp%" == "Y" (
echo;
    GOTO INSTALL
)
GOTO EOS

:EXIST
echo "starshipのconfigファイルは既にインストールされています"
echo "上書き作成しますか?[実際には設定ファイルへのシンボリックリンクが生成されます] Y/N"
set /P UserResp="入力: "
rem echo %UserResp%
IF /i "%UserResp%" == "Y" (
    GOTO INSTALL
)
GOTO EOS

:EOS
echo インストールが終わりました。

pause
