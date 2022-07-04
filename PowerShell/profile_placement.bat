@echo off
chcp 65001
rem "PowerSHellのMicrosoft.PowerShell_profile.ps1を配置します"
set PROFILE_NAME=Microsoft.PowerShell_profile.ps1
rem
echo "現在のディレクトリパス ->"%~dp0
echo "参照先のプロファイルのファイル名:"%PROFILE_NAME%

set LINK_FILE_PATH=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

echo ===================================================

rem リンクファイルが存在するかどうか
IF EXIST %LINK_FILE_PATH%. (
    echo true
    rm %LINK_FILE_PATH%
    sudo mklink %LINK_FILE_PATH% %~dp0%PROFILE_NAME%
) else (
    echo false
    mkdir %LINK_FILE_PATH%
    sudo mklink %LINK_FILE_PATH% %~dp0%PROFILE_NAME%
)

rem ) ELSE (
rem     echo "すでにファイルが存在しています"
rem     echo それでも置き換えますか？<Y/N>
rem     set /P UserResp="入力: "
rem     if /i "%UserResp%" == "Y" (
rem         mklink %LINK_FILE_PATH% %~dp0\%PROFILE_NAME%
rem     )
rem )

rem IF NOT EXIST %USERPROFILE%\.config\starship.toml (
rem     echo "starshipの設定ファイル[~\.config\starshop.toml]"
rem     echo "を作成しますか?[実際には設定ファイルへのシンボリックリンクが生成されます] Y/N"
rem     set /P UserResp="入力: "
rem     rem echo %UserResp%
rem     IF /i "%UserResp%" == "Y" (
rem         WHERE /Q scoop
rem         IF "%ERRORELEVEL%" == "1" (
rem             echo "PowerShellをインストールします"
rem             winget install --id Microsoft.PowerShell --source winget
rem         )
rem         pwsh -ExecutionPolicy RemoteSigned .\starship_install.ps1
rem     )
rem )

@pause
