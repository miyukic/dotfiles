#Set-StrictMode -Version Latest


#コマンド存在チェック
#true or falseで返る
function IsExistCommand([string] $command) {
    Get-Command $command -ea SilentlyContinue | Out-Null
    return $?
}


[Boolean] $result = IsExistCommand("pwsh")
if ($result) { #存在する場合
    Write-Output "PowerShell(pwsh)はインストール済みです"
} else { #存在しない場合
    winget install PowerShell.Windows
    $result = IsExistCommand("pwsh")
    if ($result) { 
        Write-Output "powershell(pwsh)のインストールに失敗しました"
        exit
    }
}
}

$result = IsExistCommand("scoop")
if ($result) { 
    Write-Output "scoopはインストール済みです"
} else { 
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force iwr -useb get.scoop.sh | iex
    $result = IsExistCommand("scoop")
    if ($result) {
        Write-Output "scoopのインストールに失敗しました"
        exit
    }
}


echo "scoopのバケットを追加処理します"
[string[]]$installExtraBuckets = @("extras","versions","github-gh")
[string[]]$notexists = @()
$installExtraBuckets | Where-Object {
    if ((scoop bucket list | Select-Object Name | ForEach-Object Name) -notcontains $_) {
        $notexists += $_
    }
}
$notexists | ForEach-Object {Write-Output "scoopに $_ bucket を追加します"; scoop bucket add $_ }

$installCommandList=@(
    "7zip","git","curl","fzf","git", "gsudo","lsd","neovim","vim-nightly","starship","winfetch", "less"
)

#micro, ripgrep, lessmsi, gow

#$installCommandList | ForEach-Object { 
#    $result=IsExistCommand($_); if ($result -eq $false) {scoop install $_}
#}

[string[]]$notexists = @()
$scoopList = $(scoop list)
$installCommandList | ForEach-Object {
    if (($scoopList | Select-Object Name | ForEach-Object Name) -notcontains $_) {
        $notexists += $_
    }
}

$notexists | ForEach-Object {
    Write-Output "$_をインストールします"
    scoop install $_
}
