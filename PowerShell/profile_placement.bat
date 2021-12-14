@echo off
chcp 65001
rem "PowerSHellのMicrosoft.PowerShell_profile.ps1を配置します"
set PROFILE_NAME=Microsoft.PowerShell_profile.ps1

echo "現在のディレクトリパス:"
echo %~dp0
echo "参照先のプロファイルのファイル名:"%PROFILE_NAME%

set LINK_FILE_PATH=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

rem リンクファイルが存在するかどうか
IF not exist %LINK_FILE_PATH% (
    mklink %LINK_FILE_PATH% %~dp0\%PROFILE_NAME%
) else (
    echo "すでにファイルが存在しています"
)

@pause
