#Set-StrictMode -Version Latest

# NuGetプロバイダーのインストール（Install-Moduleの前提条件）
$result = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
if ($result) { Write-Output "NuGet Provider is Installed" }

function Install-ModuleEx([string]$Name, $Args) {
    if (Get-Module -ListAvailable -Name $Name) {
    } else {
        Install-Module -Name $Name -Force -Scope CurrentUser
    }
}

#PowerShellGetのインストール
Install-ModuleEx -Name PowerShellGet
#PSReadLineのインストール
Install-ModuleEx -Name PSReadLine
#DockerCompletion
if (-Not (Get-Module -ListAvailable -Name DockerCompletion)) {
    Install-Module DockerCompletion -Scope CurrentUser -Force
}


#コマンド存在チェック
#true or falseで返る
function IsExistCommand([string] $command) {
    Get-Command $command -ea SilentlyContinue | Out-Null
    return $?
}


[Boolean] $result = IsExistCommand("pwsh")
if ($result) { #存在する場合
    Write-Output "pwsh is already installed."
} else { #存在しない場合
    winget install PowerShell.Windows --accept-source-agreements --accept-package-agreements
    $result = IsExistCommand("pwsh")
    if ($result) { 
        Write-Output "Flailed to install pwsh."
        exit
    }
}


$result = IsExistCommand("scoop")
if ($result) { 
    Write-Output "scoop is already installed."
} else { 
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
    $result = IsExistCommand("scoop")
    if ($result) {
        Write-Output "Faled to install scoop."
        exit
    }
}


echo "Adding scoop buckets..."
[string[]]$installExtraBuckets = @("extras","versions")
[string[]]$notexists = @()
$installExtraBuckets | Where-Object {
    if ((scoop bucket list | Select-Object Name | ForEach-Object Name) -notcontains $_) {
        $notexists += $_
    }
}
$notexists | ForEach-Object {Write-Output "Adding $_ bucket to scoop."; scoop bucket add $_ }

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
    Write-Output "Installing $_."
    scoop install $_
}

