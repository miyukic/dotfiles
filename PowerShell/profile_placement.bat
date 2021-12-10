@echo off
rem PowerSHellのMicrosoft.PowerShell_profile.ps1を配置します
set PROFILE_NAME=Microsoft.PowerShell_profile.ps1

echo 現在のディレクトリパス:
echo %~dp0
echo 参照先のプロファイルのファイル名:%PROFILE_NAME%

mklink /D %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 %~dp0\%PROFILE_NAME%
@pause
