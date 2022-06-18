Set-StrictMode -Version Latest


#コマンド存在チェック
#true or falseで返る
function IsExistCommand([string] $command) {
    Get-Command $command -ea SilentlyContinue | Out-Null
    return $?
}

[Boolean] $result = IsExistCommand("pwsh")
if ($result) { #存在する場合
    echo "PowerShell(pwsh)はインストール済みです"
} else { #存在しない場合
    winget install PowerShell.Windows
    $result = IsExistCommand("pwsh")
    if ($result) { 
        echo "powershell(pwsh)のインストールに失敗しました"
        exit
    }
}

$result = IsExistCommand("scoop")
if ($result) { 
    echo "scoopはインストール済みです"
} else { 
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force iwr -useb get.scoop.sh | iex
    $result = IsExistCommand("scoop")
    if ($result) {
        echo "scoopのインストールに失敗しました"
        exit
    }
}

$installExtraBuckets=@("extras","versions","github-gh")
$notexists = $installExtraBuckets | 
Where-Object {(scoop bucket list | select Name | ForEach-Object Name) -notcontains $_ }
$notexists | % {echo "scoopに $_ bucket を追加します"; scoop bucket add $_ }

$installCommandList=@("7zip","git","curl","fzf","git","gsudo","lsd","neovim","vim-nightly","starship","winfetch")
#micro, ripgrep

$installCommandList | ForEach-Object { 
    $result=IsExistCommand($_); if ($result -eq $false) {scoop install $_}
}

