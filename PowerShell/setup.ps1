Set-StrictMode -Version Latest


#コマンド存在チェック
#true or falseで返る
function IsExistCommand([string] $command) {
    Get-Command $command -ea SilentlyContinue | Out-Null
    return $?
}

[Boolean] $result = IsExistCommand("pwshhh")
if ($result) { #存在する場合
} else { #存在しない場合
    winget install PowerShell.Windows
}
