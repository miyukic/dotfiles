# "PowerSHellのMicrosoft.PowerShell_profile.ps1を配置します"
$PROFILE_NAME="Microsoft.PowerShell_profile.ps1"

echo "現在のディレクトリパス:"
echo pwd 
echo "参照先のプロファイルのファイル名: ${PROFILE_NAME}"

$LINK_FILE_PATH="~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# リンクファイルが存在するかどうか
IF not exist %LINK_FILE_PATH% (
    mklink %LINK_FILE_PATH% %~dp0\%PROFILE_NAME%
) else (
    echo "すでにファイルが存在しています"
)

@pause
