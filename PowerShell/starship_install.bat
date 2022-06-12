rem @echo off
chcp 65001
@rem scoopコマンド存在確認

WHERE /Q scoop
echo %ERRORELEVEL%
IF "%ERRORELEVEL%" == "1" (
    echo "scoopコマンドがありません"
    echo "starshipをインストールするにはscoopが必要です"
    rem scoopのインストール
    echo ==================================================
    echo scoopのインストールを開始します....
    powershell -c Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    rem scoopのインストール
    powershell -c iwr -useb get.scoop.sh | iex && echo scoopのインストールが完了しました。

)
echo "starshipをインストールします"
scoop install starship



@rem IF NOT EXIST %USERPROFILE%\.config (
@rem     mkdir %USERPROFILE%\.config
@rem 
@rem     setlocal
@rem     for /f "usebackq delims=" %%A in (`ver`) do set PATH=%%A
@rem     echo %PATH%
@rem 
@rem     rem mklink %USERPROFILE%\.config\starship.toml %~dp0
@rem ) ELSE (
@rem     echo ".configフォルダが既に存在しているため作成できませんでした"
@rem )

pwsh ./starship_install.ps1
